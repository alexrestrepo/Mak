//
//  SelectExecutor.m
//  Mak
//
//  Created by Alex Restrepo on 7/17/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "SelectExecutor.h"

#import "ExpressionExecutor.h"
#import "NSNumber+Type.h"
#import "IntermediateCodeKeyImp.h"
#import "IntermediateCodeNodeTypeImp.h"

static NSMutableDictionary <id<IntermediateCodeNode>, NSMutableDictionary <id, id<IntermediateCodeNode>> *> *JumpCache;

@implementation SelectExecutor

+ (void)initialize {
    if (self == [SelectExecutor class]) {
        JumpCache = [NSMutableDictionary new];
    }
}

- (id)executeNode:(id<IntermediateCodeNode>)node {
    NSMutableDictionary *jumpTable = JumpCache[node];
    if (!jumpTable) {
        jumpTable = [self createJumpTableForNode:node];
        JumpCache[node] = jumpTable;
    }
    
    NSArray <id<IntermediateCodeNode>> *selectChildren = [node children];
    id<IntermediateCodeNode> expressionNode = selectChildren[0];
    
    ExpressionExecutor *expressionExecutor = [[ExpressionExecutor alloc] initWithParentExecutor:self];
    id selectValue = [expressionExecutor executeNode:expressionNode];
    
    id<IntermediateCodeNode> statementNode = jumpTable[selectValue];
    if (statementNode) {
        StatementExecutor *statementExecutor = [[StatementExecutor alloc] initWithParentExecutor:self];
        [statementExecutor executeNode:statementNode];
    }
    
    self.executionCount++;
    return nil;
}

- (NSMutableDictionary <id, id<IntermediateCodeNode>> *)createJumpTableForNode:(id<IntermediateCodeNode>)node {
    NSMutableDictionary <id, id<IntermediateCodeNode>> *jumpTable = [NSMutableDictionary new];
    
    NSArray <id<IntermediateCodeNode>> *selectChildren = [node children];
    for (NSInteger i = 1; i < [selectChildren count]; i++) {
        id<IntermediateCodeNode> branchNode = selectChildren[i];
        id<IntermediateCodeNode> constantsNode = [branchNode children][0];
        id<IntermediateCodeNode> statementNode = [branchNode children][1];
        
        NSArray <id<IntermediateCodeNode>> *constantsList = [constantsNode children];
        for (id<IntermediateCodeNode> constantNode in constantsList) {
            id value = [constantNode attributeForKey:[IntermediateCodeKeyImp VALUE]];
            if (constantNode.type == [IntermediateCodeNodeTypeImp STRING_CONSTANT]) {
                value = [(NSString *)value substringToIndex:1];
            }
            jumpTable[value] = statementNode;
        }
    }
    
    return jumpTable;
}

@end
