//
//  IfStatementParser.m
//  Mak
//
//  Created by Alex Restrepo on 7/6/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "IfStatementParser.h"

#import "ExpressionParser.h"
#import "TypeChecker.h"
#import "Predefined.h"

static NSSet <id<TokenType>> *ThenSet;

@implementation IfStatementParser

+ (void)initialize {
    if (self == [IfStatementParser class]) {
        NSMutableArray *types = [NSMutableArray new];
        [types addObjectsFromArray:[[StatementParser stmtStartSet] allObjects]];
        [types addObject:[PascalTokenType THEN]];
        [types addObjectsFromArray:[[StatementParser stmtFollowSet] allObjects]];
        
        ThenSet = [NSSet setWithArray:types];
    }
}

// IF EXPR THEN STMT {ELSE STMT}
- (id<IntermediateCodeNode>)parseToken:(Token *)token {
    token = [self nextToken];
    
    id<IntermediateCodeNode> ifNode = [IntermediateCodeFactory intermediateCodeNodeWithType:[IntermediateCodeNodeTypeImp IF]];
    
    ExpressionParser *expressionParser = [[ExpressionParser alloc] initWithParent:self];
    id<IntermediateCodeNode> expressionNode = [expressionParser parseToken:token];
    [ifNode addChild:expressionNode];

    id<TypeSpec> expressionType = expressionNode ? [expressionNode typeSpec] : [Predefined undefinedType];
    if (![TypeChecker isBoolean:expressionType]) {
        [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode INCOMPATIBLE_TYPES]];
    }

    token = [self synchronizeWithSet:ThenSet];
    if (token.type == [PascalTokenType THEN]) {
        token = [self nextToken];
    } else {
        [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode MISSING_THEN]];
    }
    
    StatementParser *statementParser = [[StatementParser alloc] initWithParent:self];
    [ifNode addChild:[statementParser parseToken:token]];
    
    token = [self currentToken];
    if (token.type == [PascalTokenType ELSE]) {
        token = [self nextToken]; // consume else
        [ifNode addChild:[statementParser parseToken:token]];
    }
    
    return ifNode;
}

@end
