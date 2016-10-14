//
//  VariableParser.m
//  Mak
//
//  Created by Alex Restrepo on 10/16/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "VariableParser.h"
#import "DefinitionImpl.h"
#import "Predefined.h"
#import "IntermediateCodeNodeTypeImp.h"
#import "ExpressionParser.h"
#import "TypeFormImpl.h"
#import "TypeKeyImpl.h"
#import "TypeChecker.h"

static NSSet<PascalTokenType *> *SubscriptFieldStartSet;
static NSSet<PascalTokenType *> *RightBracketSet;

@implementation VariableParser

+ (void)initialize {
    if (self == [VariableParser class]) {
        SubscriptFieldStartSet = [NSSet setWithArray:@[
                                                       [PascalTokenType LEFT_BRACKET],
                                                       [PascalTokenType DOT]
                                                       ]];

        RightBracketSet = [NSSet setWithArray:@[
                                                [PascalTokenType RIGHT_BRACKET],
                                                [PascalTokenType EQUALS],
                                                [PascalTokenType SEMICOLON]
                                                ]];
    }
}

- (id<IntermediateCodeNode>)parseToken:(Token *)token {
    NSString *name = [[token text] lowercaseString];
    id<SymbolTableEntry> identifier = [self.symbolTableStack lookup:name];

    if (!identifier) {
        [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode IDENTIFIER_UNDEFINED]];
        identifier = [self.symbolTableStack addEntryToLocalTable:name];
        [identifier setDefinition:[DefinitionImpl UNDEFINED]];
        [identifier setTypeSpec:[Predefined undefinedType]];
    }

    return [self parseToken:token withIdentifier:identifier];
}

- (id<IntermediateCodeNode>)parseToken:(Token *)token withIdentifier:(id<SymbolTableEntry>)identifier {
    id<Definition> definitionCode = [identifier definition];
    if (definitionCode != [DefinitionImpl VARIABLE]
        && definitionCode != [DefinitionImpl VALUE_PARM]
        && definitionCode != [DefinitionImpl VAR_PARM]) {
        [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode INVALID_IDENTIFIER_USAGE]];

    }

    [identifier appendLineNumber:[token lineNumber]];
    id<IntermediateCodeNode> variableNode = [IntermediateCodeFactory intermediateCodeNodeWithType:[IntermediateCodeNodeTypeImp VARIABLE]];
    [variableNode setAttribute:identifier forKey:[IntermediateCodeKeyImp ID]];

    token = [self nextToken];

    id<TypeSpec> variableType = [identifier typeSpec];
    while ([SubscriptFieldStartSet containsObject:token.type]) {
        id<IntermediateCodeNode> subfieldNode = token.type == [PascalTokenType LEFT_BRACKET] ?
        [self parseSubscripts:variableType] : [self parseField:variableType];

        token = [self currentToken];
        variableType = [subfieldNode typeSpec];
        [variableNode addChild:subfieldNode];
    }

    [variableNode setTypeSpec:variableType];
    return variableNode;
}

- (id<IntermediateCodeNode>)parseSubscripts:(id<TypeSpec>)variableType {
    Token *token = nil;
    ExpressionParser *parser = [[ExpressionParser alloc] initWithParent:self];

    id<IntermediateCodeNode> subscriptsNode = [IntermediateCodeFactory intermediateCodeNodeWithType:[IntermediateCodeNodeTypeImp SUBSCRIPTS]];
    do {
        token = [self nextToken];
        if ([variableType form] == [TypeFormImpl ARRAY]) {
            id<IntermediateCodeNode> expressionNode = [parser parseToken:token];
            id<TypeSpec> expressionType = expressionNode ? [expressionNode typeSpec] : [Predefined undefinedType];

            id<TypeSpec> indexType = [variableType attributeForKey:[TypeKeyImpl ARRAY_INDEX_TYPE]];
            if (![TypeChecker areAssignmentCompatibleTarget:indexType value:expressionType]) {
                [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode INCOMPATIBLE_TYPES]];
            }

            [subscriptsNode addChild:expressionNode];
            variableType = [variableType attributeForKey:[TypeKeyImpl ARRAY_ELEMENT_TYPE]];

        } else {
            [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode TOO_MANY_SUBSCRIPTS]];
            [parser parseToken:token];
        }

        token = [self currentToken];

    } while (token.type == [PascalTokenType COMMA]);

    token = [self synchronizeWithSet:RightBracketSet];
    if (token.type == [PascalTokenType RIGHT_BRACKET]) {
        token = [self nextToken];
    } else {
        [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode MISSING_RIGHT_BRACKET]];
    }

    [subscriptsNode setTypeSpec:variableType];
    return subscriptsNode;
}

- (id<IntermediateCodeNode>)parseField:(id<TypeSpec>)variableType {
    id<IntermediateCodeNode> fieldNode = [IntermediateCodeFactory intermediateCodeNodeWithType:[IntermediateCodeNodeTypeImp FIELD]];

    Token *token = [self nextToken];
    id<TokenType> tokenType = token.type;
    id<TypeForm> variableForm = [variableType form];

    if (tokenType == [PascalTokenType IDENTIFIER] && variableForm == [TypeFormImpl RECORD]) {
        id<SymbolTable> symTab = [variableType attributeForKey:[TypeKeyImpl RECORD_SYMTAB]];
        NSString *fieldName = [token.text lowercaseString];
        id<SymbolTableEntry> fieldId = [symTab lookup:fieldName];

        if (fieldId) {
            variableType = [fieldId typeSpec];
            [fieldId appendLineNumber:[token lineNumber]];
            [fieldNode setAttribute:fieldId forKey:[IntermediateCodeKeyImp ID]];
        } else {
            [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode INVALID_FIELD]];
        }

    } else {
        [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode INVALID_FIELD]];
    }

    token = [self nextToken];
    [fieldNode setTypeSpec:variableType];
    
    return fieldNode;
}

@end
