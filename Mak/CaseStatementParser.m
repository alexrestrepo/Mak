//
//  CaseStatementParser.m
//  Mak
//
//  Created by Alex Restrepo on 7/6/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "CaseStatementParser.h"

#import "ExpressionParser.h"
#import "Predefined.h"
#import "TypeChecker.h"
#import "TypeFormImpl.h"
#import "DefinitionImpl.h"
#import "SymTabKey.h"

static NSSet <id<TokenType>> *ConstantStartSet;
static NSSet <id<TokenType>> *OfSet;
static NSSet <id<TokenType>> *CommaSet;

@implementation CaseStatementParser

+ (void)initialize {
    if (self == [CaseStatementParser class]) {
        ConstantStartSet = [NSSet setWithArray:@[
                                                 [PascalTokenType IDENTIFIER],
                                                 [PascalTokenType INTEGER],
                                                 [PascalTokenType PLUS],
                                                 [PascalTokenType MINUS],
                                                 [PascalTokenType STRING],
                                                 ]];
        
        NSMutableArray *types = [NSMutableArray new];
        [types addObjectsFromArray:[ConstantStartSet allObjects]];
        [types addObject:[PascalTokenType OF]];
        [types addObject:[StatementParser stmtFollowSet]];
        
        OfSet = [NSSet setWithArray:types];
        
        types = [NSMutableArray new];
        [types addObjectsFromArray:[ConstantStartSet allObjects]];
        [types addObject:[PascalTokenType COLON]];
        [types addObject:[PascalTokenType COMMA]];
        [types addObjectsFromArray:[[StatementParser stmtStartSet] allObjects]];
        [types addObjectsFromArray:[[StatementParser stmtFollowSet] allObjects]];
        
        CommaSet = [NSSet setWithArray:types];
    }
}

// CASE EXPR OF { CONST LIST : STMT ; }* END
- (id<IntermediateCodeNode>)parseToken:(Token *)token {
    token = [self nextToken]; // consume CASE
    
    id<IntermediateCodeNode> selectNode = [IntermediateCodeFactory intermediateCodeNodeWithType:[IntermediateCodeNodeTypeImp SELECT]];
    ExpressionParser *expressionParser = [[ExpressionParser alloc] initWithParent:self];
    id<IntermediateCodeNode> expressionNode = [expressionParser parseToken:token];
    [selectNode addChild:expressionNode];

    id<TypeSpec> expressionType = [expressionNode typeSpec];
    if (![TypeChecker isInteger:expressionType] && ![TypeChecker isChar:expressionType] && [expressionType form] != [TypeFormImpl ENUMERATION]) {
        [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode INCOMPATIBLE_TYPES]];
    }
    
    token = [self synchronizeWithSet:OfSet];
    if (token.type == [PascalTokenType OF]) {
        token = [self nextToken];
    } else {
        [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode MISSING_OF]];
    }
    
    NSMutableSet *constantSet = [NSMutableSet new];
    while (![token isKindOfClass:[EofToken class]] && (token.type != [PascalTokenType END])) {
        [selectNode addChild:[self parseBranchWithToken:token type:expressionType withSet:constantSet]];
        token = [self currentToken];
        id<TokenType> tokenType = token.type;
        
        if (tokenType == [PascalTokenType SEMICOLON]) {
            token = [self nextToken]; // consume ;
            
        } else if ([ConstantStartSet containsObject:tokenType]) {
            [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode MISSING_SEMICOLON]];
        }
    }
    
    if (token.type == [PascalTokenType END]) {
        token = [self nextToken];
    } else {
        [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode MISSING_END]];
    }
    
    return selectNode;
}

- (id<IntermediateCodeNode>)parseBranchWithToken:(Token *)token type:(id<TypeSpec>)expressionType withSet:(NSMutableSet *)constantSet {
    id<IntermediateCodeNode> branchNode = [IntermediateCodeFactory intermediateCodeNodeWithType:[IntermediateCodeNodeTypeImp SELECT_BRANCH]];
    id<IntermediateCodeNode> constantsNode = [IntermediateCodeFactory intermediateCodeNodeWithType:[IntermediateCodeNodeTypeImp SELECT_CONSTANTS]];
    
    [branchNode addChild:constantsNode];
    [self parseConstantListWithToken:token type:expressionType inNode:constantsNode withSet:constantSet];
    
    token = [self currentToken];
    if (token.type == [PascalTokenType COLON]) {
        token = [self nextToken];
    } else {
        [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode MISSING_COLON]];
    }
    
    StatementParser *statementParser = [[StatementParser alloc] initWithParent:self];
    [branchNode addChild:[statementParser parseToken:token]];
    
    return branchNode;
}

- (void)parseConstantListWithToken:(Token *)token type:(id<TypeSpec>)expressionType inNode:(id<IntermediateCodeNode>)constantsNode withSet:(NSMutableSet *)constantsSet {
    while ([ConstantStartSet containsObject:token.type]) {
        [constantsNode addChild:[self parseConstantWithToken:token type:expressionType withSet:constantsSet]];
        
        token = [self synchronizeWithSet:CommaSet];
        
        if (token.type == [PascalTokenType COMMA]) {
            token = [self nextToken];
            
        } else if ([ConstantStartSet containsObject:token.type]) {
            [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode MISSING_COMMA]];
        }
    }
}

- (id<IntermediateCodeNode>)parseConstantWithToken:(Token *)token type:(id<TypeSpec>)expressionType withSet:(NSMutableSet *)constantsSet {
    id<TokenType> sign = nil;
    id<IntermediateCodeNode> constantNode = nil;
    id<TypeSpec> constantType = nil;
    
    token = [self synchronizeWithSet:ConstantStartSet];
    id<TokenType> tokenType = token.type;
    
    if (tokenType == [PascalTokenType PLUS] || tokenType == [PascalTokenType MINUS]) {
        sign = tokenType;
        token = [self nextToken];
    }
    
    if (token.type == [PascalTokenType IDENTIFIER]) {
        constantNode = [self parseIdentifierConstantWithToken:token sign:sign];
        if (constantNode) {
            constantType = [constantNode typeSpec];
        }
        
    } else if (token.type == [PascalTokenType INTEGER]) {
        constantNode = [self parseIntegerConstantWithToken:token sign:sign];
        constantType = [Predefined integerType];
        
    } else if (token.type == [PascalTokenType STRING]) {
        constantNode = [self parseCharacterConstantWithToken:token sign:sign];
        constantType = [Predefined charType];
        
    } else {
        [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode INVALID_CONSTANT]];
    }
    
    if (constantNode) {
        id value = [constantNode attributeForKey:[IntermediateCodeKeyImp VALUE]];
        if ([constantsSet containsObject:value]) {
            [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode CASE_CONSTANT_REUSED]];
        } else {
            [constantsSet addObject:value];
        }
    }

    if (![TypeChecker areComparisonCompatibleType1:expressionType type2:constantType]) {
        [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode INCOMPATIBLE_TYPES]];
    }

    [self nextToken]; //consume constant
    [constantNode setTypeSpec:constantType];
    return constantNode;
}

- (id<IntermediateCodeNode>)parseIdentifierConstantWithToken:(Token *)token sign:(id<TokenType>)sign {
    id<IntermediateCodeNode> constantNode = nil;
    id<TypeSpec> constantType = nil;

    NSString *name = [token.text lowercaseString];
    id<SymbolTableEntry> identifier = [self.symbolTableStack lookup:name];
    if (!identifier) {
        identifier = [self.symbolTableStack addEntryToLocalTable:name];
        [identifier setDefinition:[DefinitionImpl UNDEFINED]];
        [identifier setTypeSpec:[Predefined undefinedType]];
        [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode IDENTIFIER_UNDEFINED]];
        return nil;
    }

    id<Definition> definitionCode = [identifier definition];
    if ((definitionCode == [DefinitionImpl CONSTANT]) || (definitionCode == [DefinitionImpl ENUMERATION_CONSTANT])) {
        id constantValue = [identifier attributeForKey:[SymTabKey CONSTANT_VALUE]];
        constantType = [identifier typeSpec];
        if (sign && ![TypeChecker isInteger:constantType]) {
            [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode INVALID_CONSTANT]];
        }

        constantNode = [IntermediateCodeFactory intermediateCodeNodeWithType:[IntermediateCodeNodeTypeImp INTEGER_CONSTANT]];
        [constantNode setAttribute:constantValue forKey:[IntermediateCodeKeyImp VALUE]];
    }

    [identifier appendLineNumber:token.lineNumber];
    if (constantNode) {
        [constantNode setTypeSpec:constantType];
    }
    return constantNode;
}

- (id<IntermediateCodeNode>)parseIntegerConstantWithToken:(Token *)token sign:(id<TokenType>)sign {
    id<IntermediateCodeNode> constantNode = [IntermediateCodeFactory intermediateCodeNodeWithType:[IntermediateCodeNodeTypeImp INTEGER_CONSTANT]];
    NSInteger intValue = [token.text integerValue];
    if (sign == [PascalTokenType MINUS]) {
        intValue = -intValue;
    }
    
    [constantNode setAttribute:@(intValue) forKey:[IntermediateCodeKeyImp VALUE]];
    return constantNode;
}

- (id<IntermediateCodeNode>)parseCharacterConstantWithToken:(Token *)token sign:(id<TokenType>)sign {
    id<IntermediateCodeNode> constantNode = nil;
    if (sign) {
        [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode INVALID_CONSTANT]];
        
    } else {
        if ([token.value length] == 1) {
            constantNode = [IntermediateCodeFactory intermediateCodeNodeWithType:[IntermediateCodeNodeTypeImp STRING_CONSTANT]];
            [constantNode setAttribute:token.value forKey:[IntermediateCodeKeyImp VALUE]];
            
        } else {
            [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode INVALID_CONSTANT]];
        }
    }
    
    return constantNode;
}

@end
