//
//  CompoundStatementParser.m
//  Mak
//
//  Created by Alex Restrepo on 6/29/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "CompoundStatementParser.h"

#import "IntermediateCodeFactory.h"
#import "IntermediateCodeNodeTypeImp.h"

@implementation CompoundStatementParser

- (id<IntermediateCodeNode>)parseToken:(Token *)token {
    token = [self nextToken]; // consume the begin
    
    id<IntermediateCodeNode> compoundNode = [IntermediateCodeFactory intermediateCodeNodeWithType:[IntermediateCodeNodeTypeImp COMPOUND]];
    StatementParser *statementParser = [[StatementParser alloc] initWithParent:self];
    [statementParser parseListFromToken:token
                             parentNode:compoundNode
                             terminator:[PascalTokenType END]
                              errorCode:[PascalErrorCode MISSING_END]];
    
    return compoundNode;
}

@end
