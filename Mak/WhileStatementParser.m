//
//  WhileStatementParser.m
//  Mak
//
//  Created by Alex Restrepo on 7/6/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "WhileStatementParser.h"

#import "ExpressionParser.h"
#import "Predefined.h"
#import "TypeChecker.h"

static NSSet <id<TokenType>> *DoSet;

@implementation WhileStatementParser

+ (void)initialize {
    if (self == [WhileStatementParser class]) {
        NSMutableArray *allTokens = [NSMutableArray new];
        [allTokens addObjectsFromArray:[[StatementParser stmtStartSet] allObjects]];
        [allTokens addObject:[PascalTokenType DO]];
        [allTokens addObjectsFromArray:[[StatementParser stmtFollowSet] allObjects]];
        
        DoSet = [NSSet setWithArray:allTokens];
    }
}

/*
 WHILE EXPR DO STMT
 */

- (id<IntermediateCodeNode>)parseToken:(Token *)token {
    token = [self nextToken]; // consume the while
    
    id<IntermediateCodeNode> loopNode = [IntermediateCodeFactory intermediateCodeNodeWithType:[IntermediateCodeNodeTypeImp LOOP]];
    id<IntermediateCodeNode> breakNode = [IntermediateCodeFactory intermediateCodeNodeWithType:[IntermediateCodeNodeTypeImp TEST]];
    id<IntermediateCodeNode> notNode = [IntermediateCodeFactory intermediateCodeNodeWithType:[IntermediateCodeNodeTypeImp NOT]];
    
    [loopNode addChild:breakNode];
    [breakNode addChild:notNode]; // cuz the false of the expresion breaks the loop
    
    ExpressionParser *expressionParser = [[ExpressionParser alloc] initWithParent:self];
    id<IntermediateCodeNode> expressionNode = [expressionParser parseToken:token];
    [notNode addChild:expressionNode];

    id<TypeSpec> expressionType = expressionNode ? [expressionNode typeSpec] : [Predefined undefinedType];
    if (![TypeChecker isBoolean:expressionType]) {
        [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode INCOMPATIBLE_TYPES]];
    }
    
    token = [self synchronizeWithSet:DoSet];
    if (token.type == [PascalTokenType DO]) {
        token = [self nextToken];
        
    } else {
        [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode MISSING_DO]];
    }
    
    StatementParser *statementParser = [[StatementParser alloc] initWithParent:self];
    [loopNode addChild:[statementParser parseToken:token]];
    
    return loopNode;
}

@end
