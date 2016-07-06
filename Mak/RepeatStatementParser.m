//
//  RepeatStatementParser.m
//  Mak
//
//  Created by Alex Restrepo on 7/6/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "RepeatStatementParser.h"

#import "ExpressionParser.h"

@implementation RepeatStatementParser

- (id<IntermediateCodeNode>)parseToken:(Token *)token {
    token = [self nextToken]; // consume the REPEAT
    
    id<IntermediateCodeNode> loopNode = [IntermediateCodeFactory intermediateCodeNodeWithType:[IntermediateCodeNodeTypeImp LOOP]];
    id<IntermediateCodeNode> testNode = [IntermediateCodeFactory intermediateCodeNodeWithType:[IntermediateCodeNodeTypeImp TEST]];
    
    StatementParser *statementParser = [[StatementParser alloc] initWithParent:self];
    [statementParser parseListFromToken:token
                             parentNode:loopNode
                             terminator:[PascalTokenType UNTIL]
                              errorCode:[PascalErrorCode MISSING_UNTIL]];
    
    token = [self currentToken];
    
    ExpressionParser *expressionParser = [[ExpressionParser alloc] initWithParent:self];
    [testNode addChild:[expressionParser parseToken:token]];
    [loopNode addChild:testNode];
    
    return loopNode;
}

@end
