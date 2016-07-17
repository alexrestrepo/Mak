//
//  LoopExecutor.m
//  Mak
//
//  Created by Alex Restrepo on 7/17/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "LoopExecutor.h"

#import "ExpressionExecutor.h"
#import "IntermediateCodeNodeTypeImp.h"

@implementation LoopExecutor

- (id)executeNode:(id<IntermediateCodeNode>)node {
    BOOL exitLoop = false;
    id<IntermediateCodeNode> expressionNode = nil;
    NSArray <id<IntermediateCodeNode>> *loopChildren = [node children];
    
    ExpressionExecutor *expressionExecutor = [[ExpressionExecutor alloc] initWithParentExecutor:self];
    StatementExecutor *statementExecutor = [[StatementExecutor alloc] initWithParentExecutor:self];
    
    while (!exitLoop) {
        self.executionCount++;
        for (id<IntermediateCodeNode> child in loopChildren) {
            id<IntermediateCodeNodeType> childType = child.type;
            if (childType == [IntermediateCodeNodeTypeImp TEST]) {
                if (!expressionNode) {
                    expressionNode = [child children][0];
                }
                exitLoop = [[expressionExecutor executeNode:expressionNode] boolValue];
                
            } else {
                [statementExecutor executeNode:child];
            }
            
            if (exitLoop) {
                break;
            }
        }
    }
    return nil;
}

@end
