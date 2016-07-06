//
//  CaseStatementParser.m
//  Mak
//
//  Created by Alex Restrepo on 7/6/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "CaseStatementParser.h"

#import "ExpressionParser.h"

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
    [selectNode addChild:[expressionParser parseToken:token]];
    
    token = [self synchronizeWithSet:OfSet];
    if (token.type == [PascalTokenType OF]) {
        token = [self nextToken];
    } else {
        [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode MISSING_OF]];
    }
    
    NSMutableSet *constantSet = [NSMutableSet new];
    while (![token isKindOfClass:[EofToken class]] && (token.type != [PascalTokenType END])) {
        [selectNode addChild:[self parseBranchWithToken:token withSet:constantSet]];
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

- (id<IntermediateCodeNode>)parseBranchWithToken:(Token *)token withSet:(NSMutableSet *)constantSet {
    id<IntermediateCodeNode> branchNode = [IntermediateCodeFactory intermediateCodeNodeWithType:[IntermediateCodeNodeTypeImp SELECT_BRANCH]];
    id<IntermediateCodeNode> constantsNode = [IntermediateCodeFactory intermediateCodeNodeWithType:[IntermediateCodeNodeTypeImp SELECT_CONSTANTS]];
    
    [branchNode addChild:constantsNode];
    [self parseConstantListWithToken:token inNode:constantsNode withSet:constantSet];
    
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

- (void)parseConstantListWithToken:(Token *)token inNode:(id<IntermediateCodeNode>)constantsNode withSet:(NSMutableSet *)constantsSet {
    while ([ConstantStartSet containsObject:token.type]) {
        [constantsNode addChild:[self parseConstantWithToken:token withSet:constantsSet]];
        
        token = [self synchronizeWithSet:CommaSet];
        
        if (token.type == [PascalTokenType COMMA]) {
            token = [self nextToken];
            
        } else if ([ConstantStartSet containsObject:token.type]) {
            [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode MISSING_COMMA]];
        }
    }
}

- (id<IntermediateCodeNode>)parseConstantWithToken:(Token *)token withSet:(NSMutableSet *)constantsSet {
    id<TokenType> sign = nil;
    id<IntermediateCodeNode> constantNode = nil;
    
    token = [self synchronizeWithSet:ConstantStartSet];
    id<TokenType> tokenType = token.type;
    
    if (tokenType == [PascalTokenType PLUS] || tokenType == [PascalTokenType MINUS]) {
        sign = tokenType;
        token = [self nextToken];
    }
    
    if (token.type == [PascalTokenType IDENTIFIER]) {
        constantNode = [self parseIdentifierConstantWithToken:token sign:sign];
        
    } else if (token.type == [PascalTokenType INTEGER]) {
        constantNode = [self parseIntegerConstantWithToken:token sign:sign];
        
    } else if (token.type == [PascalTokenType STRING]) {
        constantNode = [self parseCharacterConstantWithToken:token sign:sign];
        
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
    
    [self nextToken]; //consume constant
    return constantNode;
}

- (id<IntermediateCodeNode>)parseIdentifierConstantWithToken:(Token *)token sign:(id<TokenType>)sign {
    // don't allow for now
    [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode INVALID_CONSTANT]];
    return nil;
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
