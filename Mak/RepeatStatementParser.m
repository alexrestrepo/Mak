//
//  RepeatStatementParser.m
//  Mak
//
//  Created by Alex Restrepo on 7/6/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "RepeatStatementParser.h"

#import "ExpressionParser.h"
#import "Predefined.h"
#import "TypeChecker.h"

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
    id<IntermediateCodeNode> expressionNode = [expressionParser parseToken:token];
    [testNode addChild:expressionNode];
    [loopNode addChild:testNode];

    id<TypeSpec> expressionType = expressionNode ? [expressionNode typeSpec] : [Predefined undefinedType];
    if (![TypeChecker isBoolean:expressionType]) {
        [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode INCOMPATIBLE_TYPES]];
    }
    
    return loopNode;
}

@end
