//
//  ForStatementParser.m
//  Mak
//
//  Created by Alex Restrepo on 7/6/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "ForStatementParser.h"

#import "ExpressionParser.h"
#import "AssignmentStatementParser.h"
#import "IntermediateCodeNodeImp.h"

static NSSet <id<TokenType>> *ToDowntoSet;
static NSSet <id<TokenType>> *DoSet;

@implementation ForStatementParser

+ (void)initialize {
    if (self == [ForStatementParser class]) {
        NSMutableArray <id<TokenType>> *allTokens = [NSMutableArray new];
        [allTokens addObjectsFromArray:[[ExpressionParser exprStartSet] allObjects]];
        [allTokens addObject:[PascalTokenType TO]];
        [allTokens addObject:[PascalTokenType DOWNTO]];
        [allTokens addObjectsFromArray:[[StatementParser stmtFollowSet] allObjects]];
        
        ToDowntoSet = [NSSet setWithArray:allTokens];
        
        allTokens = [NSMutableArray new];
        [allTokens addObjectsFromArray:[[StatementParser stmtStartSet] allObjects]];
        [allTokens addObject:[PascalTokenType DO]];
        [allTokens addObjectsFromArray:[[StatementParser stmtFollowSet] allObjects]];
        
        DoSet = [NSSet setWithArray:allTokens];
    }
}

// FOR ID := EXPR (TO|DOWNTO) EXPR DO STATEMENT

- (id<IntermediateCodeNode>)parseToken:(Token *)token {
    token = [self nextToken]; // consume FOR
    Token *targetToken = token;
    
    id<IntermediateCodeNode> compoundNode = [IntermediateCodeFactory intermediateCodeNodeWithType:[IntermediateCodeNodeTypeImp COMPOUND]];
    id<IntermediateCodeNode> loopNode = [IntermediateCodeFactory intermediateCodeNodeWithType:[IntermediateCodeNodeTypeImp LOOP]];
    id<IntermediateCodeNode> testNode = [IntermediateCodeFactory intermediateCodeNodeWithType:[IntermediateCodeNodeTypeImp TEST]];
    
    AssignmentStatementParser *assignmentParser = [[AssignmentStatementParser alloc] initWithParent:self];
    id<IntermediateCodeNode> initAssignNode = [assignmentParser parseToken:token];
    
    [self setLineNumberInNode:initAssignNode forToken:targetToken];
    
    [compoundNode addChild:initAssignNode];
    [compoundNode addChild:loopNode];
    
    token = [self synchronizeWithSet:ToDowntoSet];
    id<TokenType> direction = token.type;
    
    if (direction == [PascalTokenType TO] || direction == [PascalTokenType DOWNTO]) {
        token = [self nextToken];
        
    } else {
        direction = [PascalTokenType TO];
        [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode MISSING_TO_DOWNTO]];
    }
    
    id<IntermediateCodeNode> relOpNode = [IntermediateCodeFactory intermediateCodeNodeWithType:(direction == [PascalTokenType TO]
                                                                                                ? [IntermediateCodeNodeTypeImp GT]
                                                                                                : [IntermediateCodeNodeTypeImp LT])];
    
    IntermediateCodeNodeImp *controlVarNode = [initAssignNode children][0];
    [relOpNode addChild:[controlVarNode copy]];
    
    ExpressionParser *expressionParser = [[ExpressionParser alloc] initWithParent:self];
    [relOpNode addChild:[expressionParser parseToken:token]];
    
    [testNode addChild:relOpNode];
    [loopNode addChild:testNode];
    
    token = [self synchronizeWithSet:DoSet];
    if (token.type == [PascalTokenType DO]) {
        token = [self nextToken];
        
    } else {
        [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode MISSING_DO]];
    }
    
    StatementParser *statementParser = [[StatementParser alloc] initWithParent:self];
    [loopNode addChild:[statementParser parseToken:token]];
    
    id<IntermediateCodeNode> nextAssignNode = [IntermediateCodeFactory intermediateCodeNodeWithType:[IntermediateCodeNodeTypeImp ASSIGN]];
    [nextAssignNode addChild:[controlVarNode copy]];
    
    id<IntermediateCodeNode> arithOpNode = [IntermediateCodeFactory intermediateCodeNodeWithType:(direction == [PascalTokenType TO]
                                                                                                  ? [IntermediateCodeNodeTypeImp ADD]
                                                                                                  : [IntermediateCodeNodeTypeImp SUBTRACT])];
    [arithOpNode addChild:[controlVarNode copy]];
    
    id<IntermediateCodeNode> oneNode = [IntermediateCodeFactory intermediateCodeNodeWithType:[IntermediateCodeNodeTypeImp INTEGER_CONSTANT]];
    [oneNode setAttribute:@(1) forKey:[IntermediateCodeKeyImp VALUE]];
    [arithOpNode addChild:oneNode];
    
    [nextAssignNode addChild:arithOpNode];
    [loopNode addChild:nextAssignNode];
    
    [self setLineNumberInNode:nextAssignNode forToken:targetToken];
    return compoundNode;
}

@end
