//
//  ExpressionParser.m
//  Mak
//
//  Created by Alex Restrepo on 6/30/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "ExpressionParser.h"

#import "SymTabStack.h"
#import "SymTab.h"
#import "SymTabEntry.h"
#import "TypeSpec.h"
#import "Predefined.h"
#import "TypeChecker.h"
#import "PascalTokenType.h"
#import "TypeFactory.h"
#import "DefinitionImpl.h"
#import "SymTabKey.h"
#import "NSNumber+Type.h"
#import "VariableParser.h"

static NSSet <PascalTokenType *> *Relops;
static NSDictionary <PascalTokenType *, id<IntermediateCodeNodeType>> *RelopMap;

static NSSet <PascalTokenType *> *Addops;
static NSDictionary <PascalTokenType *, id<IntermediateCodeNodeType>> *AddopMap;

static NSSet <PascalTokenType *> *Multops;
static NSDictionary <PascalTokenType *, id<IntermediateCodeNodeType>> *MultopMap;

static NSSet <id<TokenType>> *ExprStartSet;

@implementation ExpressionParser

+ (void)initialize {
    if (self == [ExpressionParser class]) {
        Relops = [NSSet setWithArray:@[[PascalTokenType EQUALS],
                                       [PascalTokenType NOT_EQUALS],
                                       [PascalTokenType LESS_THAN],
                                       [PascalTokenType LESS_EQUALS],
                                       [PascalTokenType GREATER_THAN],
                                       [PascalTokenType GREATER_EQUALS]]];
        
        RelopMap = @{[PascalTokenType EQUALS]:[IntermediateCodeNodeTypeImp EQ],
                     [PascalTokenType NOT_EQUALS]:[IntermediateCodeNodeTypeImp NE],
                     [PascalTokenType LESS_THAN]:[IntermediateCodeNodeTypeImp LT],
                     [PascalTokenType LESS_EQUALS]:[IntermediateCodeNodeTypeImp LE],
                     [PascalTokenType GREATER_THAN]:[IntermediateCodeNodeTypeImp GT],
                     [PascalTokenType GREATER_EQUALS]:[IntermediateCodeNodeTypeImp GE]};
        
        Addops = [NSSet setWithArray:@[[PascalTokenType PLUS],
                                       [PascalTokenType MINUS],
                                       [PascalTokenType OR]]];
        
        AddopMap = @{[PascalTokenType PLUS]:[IntermediateCodeNodeTypeImp ADD],
                     [PascalTokenType MINUS]:[IntermediateCodeNodeTypeImp SUBTRACT],
                     [PascalTokenType OR]:[IntermediateCodeNodeTypeImp OR],};
        
        
        Multops = [NSSet setWithArray:@[[PascalTokenType STAR],
                                        [PascalTokenType SLASH],
                                        [PascalTokenType DIV],
                                        [PascalTokenType MOD],
                                        [PascalTokenType AND]]];
        
        MultopMap = @{[PascalTokenType STAR]:[IntermediateCodeNodeTypeImp MULTIPLY],
                      [PascalTokenType SLASH]:[IntermediateCodeNodeTypeImp FLOAT_DIVIDE],
                      [PascalTokenType DIV]:[IntermediateCodeNodeTypeImp INTEGER_DIVIDE],
                      [PascalTokenType MOD]:[IntermediateCodeNodeTypeImp MOD],
                      [PascalTokenType AND]:[IntermediateCodeNodeTypeImp AND]};
        
        ExprStartSet = [NSSet setWithArray:@[
                                             [PascalTokenType IDENTIFIER],
                                             [PascalTokenType INTEGER],
                                             [PascalTokenType LEFT_PAREN],
                                             [PascalTokenType MINUS],
                                             [PascalTokenType NOT],
                                             [PascalTokenType PLUS],
                                             [PascalTokenType REAL],
                                             [PascalTokenType STRING],
                                             ]];
    }
}

+ (NSSet *)exprStartSet {
    return ExprStartSet;
}

- (id<IntermediateCodeNode>)parseToken:(Token *)token {
    return [self parseExpressionWithToken:token];
}

- (id<IntermediateCodeNode>)parseExpressionWithToken:(Token *)token {
    id<IntermediateCodeNode> rootNode = [self parseSimpleExpressionWithToken:token];

    id<TypeSpec> resultType = rootNode ? [rootNode typeSpec] : [Predefined undefinedType];
    
    token = [self currentToken];
    id<TokenType> tokenType = token.type;
    
    if ([Relops containsObject:tokenType]) {
        id<IntermediateCodeNodeType> nodeType = [RelopMap objectForKey:tokenType];
        id<IntermediateCodeNode> opNode = [IntermediateCodeFactory intermediateCodeNodeWithType:nodeType];
        [opNode addChild:rootNode];
        
        token = [self nextToken];
        id<IntermediateCodeNode> simpleExpression = [self parseSimpleExpressionWithToken:token];
        [opNode addChild:simpleExpression];

        rootNode = opNode;

        id<TypeSpec> simpleExpressionType = simpleExpression ? [simpleExpression typeSpec] : [Predefined undefinedType];
        if ([TypeChecker areComparisonCompatibleType1:resultType type2:simpleExpressionType]) {
            resultType = [Predefined booleanType];

        } else {
            [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode INCOMPATIBLE_TYPES]];
            resultType = [Predefined undefinedType];
        }
    }

    if (rootNode) {
        [rootNode setTypeSpec:resultType];
    }
    
    return rootNode;
}

- (id<IntermediateCodeNode>)parseSimpleExpressionWithToken:(Token *)token {
    Token *signToken = nil;
    id<TokenType> signType = nil;
    
    id<TokenType> tokenType = token.type;
    if (tokenType == [PascalTokenType PLUS] || tokenType == [PascalTokenType MINUS]) {
        signType = tokenType;
        signToken = token;
        token = [self nextToken]; // consume leading sign
    }
    
    id<IntermediateCodeNode> rootNode = [self parseTermWithToken:token];
    id<TypeSpec> resultType = rootNode ? [rootNode typeSpec] : [Predefined undefinedType];

    if (signType && ![TypeChecker isIntegerOrReal:resultType]) {
        [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode INCOMPATIBLE_TYPES]];
    }

    if (signType == [PascalTokenType MINUS]) {
        // leading -?
        id<IntermediateCodeNode> negateNode = [IntermediateCodeFactory intermediateCodeNodeWithType:[IntermediateCodeNodeTypeImp NEGATE]];
        [negateNode addChild:rootNode];
        [negateNode setTypeSpec:[rootNode typeSpec]];
        rootNode = negateNode;
    }
    
    token = [self currentToken];
    tokenType = token.type;
    
    while ([Addops containsObject:tokenType]) {
        id<TokenType> operator = tokenType;

        id<IntermediateCodeNodeType> nodeType = [AddopMap objectForKey:tokenType];
        id<IntermediateCodeNode> opNode = [IntermediateCodeFactory intermediateCodeNodeWithType:nodeType];
        [opNode addChild:rootNode];
        
        token = [self nextToken];

        id<IntermediateCodeNode> termNode = [self parseTermWithToken:token];
        [opNode addChild:termNode];
        id<TypeSpec> termType = termNode ? [termNode typeSpec] : [Predefined undefinedType];
        
        rootNode = opNode;

        if (operator == [PascalTokenType PLUS] || operator == [PascalTokenType MINUS]) {
            if ([TypeChecker areBothIntegers:resultType and:termType]) {
                resultType = [Predefined integerType];

            } else if ([TypeChecker isAtLeastOneReal:resultType or:termType]) {
                resultType = [Predefined realType];

            } else {
                [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode INCOMPATIBLE_TYPES]];
            }

        } else if (operator == [PascalTokenType OR]) {
            if ([TypeChecker areBothBoolean:resultType and:termType]) {
                resultType = [Predefined booleanType];

            } else {
                [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode INCOMPATIBLE_TYPES]];
            }
        }

        [rootNode setTypeSpec:resultType];
        token = [self currentToken];
        tokenType = token.type;
    }
    
    return rootNode;
}

- (id<IntermediateCodeNode>)parseTermWithToken:(Token *)token {
    id<IntermediateCodeNode> rootNode = [self parseFactorWithToken:token];
    id<TypeSpec> resultType = rootNode ? [rootNode typeSpec] : [Predefined undefinedType];
    
    token = [self currentToken];
    id<TokenType> tokenType = token.type;
    
    while ([Multops containsObject:tokenType]) {
        id<TokenType> operator = tokenType;

        id<IntermediateCodeNodeType> nodeType = [MultopMap objectForKey:tokenType];
        id<IntermediateCodeNode> opNode = [IntermediateCodeFactory intermediateCodeNodeWithType:nodeType];
        [opNode addChild:rootNode];
        
        token = [self nextToken];

        id<IntermediateCodeNode> factorNode = [self parseFactorWithToken:token];
        [opNode addChild:factorNode];
        id<TypeSpec> factorType = factorNode ? [factorNode typeSpec] : [Predefined undefinedType];
        
        rootNode = opNode;

        if (operator == [PascalTokenType STAR]) {
            if ([TypeChecker areBothIntegers:resultType and:factorType]) {
                resultType = [Predefined integerType];

            } else if ([TypeChecker isAtLeastOneReal:resultType or:factorType]) {
                resultType = [Predefined realType];

            } else {
                [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode INCOMPATIBLE_TYPES]];
            }

        } else if (operator == [PascalTokenType SLASH]) {
            if ([TypeChecker areBothIntegers:resultType and:factorType] || [TypeChecker isAtLeastOneReal:resultType or:factorType]) {
                resultType = [Predefined realType];

            } else {
                [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode INCOMPATIBLE_TYPES]];
            }

        } else if (operator == [PascalTokenType DIV] || operator == [PascalTokenType MOD]) {
            if ([TypeChecker areBothIntegers:resultType and:factorType]) {
                resultType = [Predefined booleanType];

            } else {
                [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode INCOMPATIBLE_TYPES]];
            }

        } else if (operator == [PascalTokenType AND]) {
            if ([TypeChecker areBothBoolean:resultType and:factorType]) {
                resultType = [Predefined booleanType];

            } else {
                [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode INCOMPATIBLE_TYPES]];
            }
        }

        [rootNode setTypeSpec:resultType];

        token = [self currentToken];
        tokenType = token.type;
    }
    
    return rootNode;
}

- (id<IntermediateCodeNode>)parseFactorWithToken:(Token *)token {
    id<TokenType> tokenType = token.type;
    id<IntermediateCodeNode> rootNode = nil;
    
    if (tokenType == [PascalTokenType IDENTIFIER]) {
        return [self parseIdentifierWithToken:token];
        
    } else if (tokenType == [PascalTokenType INTEGER]) {
        rootNode = [IntermediateCodeFactory intermediateCodeNodeWithType:[IntermediateCodeNodeTypeImp INTEGER_CONSTANT]];
        [rootNode setAttribute:token.value forKey:[IntermediateCodeKeyImp VALUE]];
        
        token = [self nextToken];
        [rootNode setTypeSpec:[Predefined integerType]];
        
    } else if (tokenType == [PascalTokenType REAL]) {
        rootNode = [IntermediateCodeFactory intermediateCodeNodeWithType:[IntermediateCodeNodeTypeImp REAL_CONSTANT]];
        [rootNode setAttribute:token.value forKey:[IntermediateCodeKeyImp VALUE]];
        
        token = [self nextToken];
        [rootNode setTypeSpec:[Predefined realType]];
        
    } else if (tokenType == [PascalTokenType STRING]) {
        rootNode = [IntermediateCodeFactory intermediateCodeNodeWithType:[IntermediateCodeNodeTypeImp STRING_CONSTANT]];
        [rootNode setAttribute:token.value forKey:[IntermediateCodeKeyImp VALUE]];

        id<TypeSpec> resultType = [token.value length] == 1? [Predefined charType] : [TypeFactory typeWithString:token.value];
        
        token = [self nextToken];
        [rootNode setTypeSpec:resultType];
        
        
    } else if (tokenType == [PascalTokenType NOT]) {
        token = [self nextToken]; //consume not
        
        rootNode = [IntermediateCodeFactory intermediateCodeNodeWithType:[IntermediateCodeNodeTypeImp NOT]];

        id<IntermediateCodeNode> factorNode = [self parseFactorWithToken:token];
        [rootNode addChild:factorNode];

        id<TypeSpec> resultType = factorNode ? [factorNode typeSpec] : [Predefined undefinedType];
        if (![TypeChecker isBoolean:resultType]) {
            [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode INCOMPATIBLE_TYPES]];
        }
        [rootNode setTypeSpec:[Predefined booleanType]];
        
    } else if (tokenType == [PascalTokenType LEFT_PAREN]) {
        token = [self nextToken]; // consume (
        
        rootNode = [self parseExpressionWithToken:token];
        id<TypeSpec> resultType = rootNode ? [rootNode typeSpec] : [Predefined undefinedType];
        token = [self currentToken];
        
        if (token.type == [PascalTokenType RIGHT_PAREN]) {
            token = [self nextToken]; //consume )
            
        } else {
            [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode MISSING_RIGHT_PAREN]];
        }

        [rootNode setTypeSpec:resultType];
        
    } else {
        [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode UNEXPECTED_TOKEN]];
        
    }
    
    return rootNode;
}

- (id<IntermediateCodeNode>)parseIdentifierWithToken:(Token *)token {
    id<IntermediateCodeNode> rootNode = nil;

    NSString *name = [[token text] lowercaseString];
    id<SymbolTableEntry> identifier = [self.symbolTableStack lookup:name];

    if (!identifier) {
        [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode IDENTIFIER_UNDEFINED]];
        identifier = [self.symbolTableStack addEntryToLocalTable:name];
        [identifier setDefinition:[DefinitionImpl UNDEFINED]];
        [identifier setTypeSpec:[Predefined undefinedType]];
    }

    id<Definition> definitionCode = [identifier definition];
    if (definitionCode == [DefinitionImpl CONSTANT]) {
        id value = [identifier attributeForKey:[SymTabKey CONSTANT_VALUE]];
        id<TypeSpec> type = [identifier typeSpec];

        if ([value isKindOfClass:[NSNumber class]] && [value arg_isInteger]) {
            rootNode = [IntermediateCodeFactory intermediateCodeNodeWithType:[IntermediateCodeNodeTypeImp INTEGER_CONSTANT]];
            [rootNode setAttribute:value forKey:[IntermediateCodeKeyImp VALUE]];

        } else if ([value isKindOfClass:[NSNumber class]] && [value arg_isFloat]) {
            rootNode = [IntermediateCodeFactory intermediateCodeNodeWithType:[IntermediateCodeNodeTypeImp REAL_CONSTANT]];
            [rootNode setAttribute:value forKey:[IntermediateCodeKeyImp VALUE]];

        } else if ([value isKindOfClass:[NSString class]]) {
            rootNode = [IntermediateCodeFactory intermediateCodeNodeWithType:[IntermediateCodeNodeTypeImp STRING_CONSTANT]];
            [rootNode setAttribute:value forKey:[IntermediateCodeKeyImp VALUE]];
        }

        [identifier appendLineNumber:[token lineNumber]];
        token = [self nextToken];

        if (rootNode) {
            [rootNode setTypeSpec:type];
        }

    } else if (definitionCode == [DefinitionImpl ENUMERATION_CONSTANT]) {
        id value = [identifier attributeForKey:[SymTabKey CONSTANT_VALUE]];
        id<TypeSpec> type = [identifier typeSpec];

        rootNode = [IntermediateCodeFactory intermediateCodeNodeWithType:[IntermediateCodeNodeTypeImp INTEGER_CONSTANT]];
        [rootNode setAttribute:value forKey:[IntermediateCodeKeyImp VALUE]];

        [identifier appendLineNumber:[token lineNumber]];
        token = [self nextToken];

        [rootNode setTypeSpec:type];

    } else {
        VariableParser *variableParser = [[VariableParser alloc] initWithParent:self];
        rootNode = [variableParser parseToken:token withIdentifier:identifier];
    }

    return rootNode;
}

@end
