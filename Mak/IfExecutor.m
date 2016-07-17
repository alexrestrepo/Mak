//
//  IfExecutor.m
//  Mak
//
//  Created by Alex Restrepo on 7/17/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "IfExecutor.h"

#import "ExpressionExecutor.h"

@implementation IfExecutor

- (id)executeNode:(id<IntermediateCodeNode>)node {
    NSArray <id<IntermediateCodeNode>> *children = [node children];
    id<IntermediateCodeNode> expressionNode = children[0];
    id<IntermediateCodeNode> thenStatementNode = children[1];
    id<IntermediateCodeNode> elseStatementNode = [children count] > 2 ? children[2] : nil;
    
    ExpressionExecutor *expressionExecutor = [[ExpressionExecutor alloc] initWithParentExecutor:self];
    StatementExecutor *statementExecutor = [[StatementExecutor alloc] initWithParentExecutor:self];
    
    BOOL test = [[expressionExecutor executeNode:expressionNode] boolValue];
    if (test) {
        [statementExecutor executeNode:thenStatementNode];
        
    } else if (elseStatementNode) {
        [statementExecutor executeNode:elseStatementNode];
    }
    
    self.executionCount++;
    return nil;
}

@end
