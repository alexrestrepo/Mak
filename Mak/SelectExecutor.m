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

@implementation SelectExecutor

- (id)executeNode:(id<IntermediateCodeNode>)node {
    NSArray <id<IntermediateCodeNode>> *selectChildren = [node children];
    id<IntermediateCodeNode> expressionNode = selectChildren[0];
    
    ExpressionExecutor *expressionExecutor = [[ExpressionExecutor alloc] initWithParentExecutor:self];
    id selectValue = [expressionExecutor executeNode:expressionNode];
    
    id<IntermediateCodeNode> selectedBranchNode = [self searchBranchesWithValue:selectValue inNodes:selectChildren];
    if (selectedBranchNode) {
        id<IntermediateCodeNode> statementNode = [selectedBranchNode children][1];
        StatementExecutor *statementExecutor = [[StatementExecutor alloc] initWithParentExecutor:self];
        [statementExecutor executeNode:statementNode];
    }
    
    self.executionCount++;
    return nil;
}

- (id<IntermediateCodeNode>)searchBranchesWithValue:(id)selectValue inNodes:(NSArray <id<IntermediateCodeNode>> *)selectChildren {
    for (NSInteger i = 1; i < [selectChildren count]; i++) { // 0 is the test value
        id<IntermediateCodeNode> branchNode = selectChildren[i];
        if ([self searchConstantsWithValue:selectValue inNode:branchNode]) {
            return  branchNode;
        }
    }
    
    return nil;
}

- (BOOL)searchConstantsWithValue:(id)selectValue inNode:(id<IntermediateCodeNode>)branchNode {
    const BOOL stringMode = [selectValue isKindOfClass:[NSString class]];
    
    id<IntermediateCodeNode> constantsNode = [branchNode children][0];
    NSArray <id<IntermediateCodeNode>> *constantsList = [constantsNode children];
    
    if (stringMode) {
        for (id<IntermediateCodeNode> constantNode in constantsList) {
            NSString *constant = [constantNode attributeForKey:[IntermediateCodeKeyImp VALUE]];
            if ([constant isEqualToString:selectValue]) {
                return true;
            }
        }
        
    } else {
        for (id<IntermediateCodeNode> constantNode in constantsList) {
            NSInteger constant = [[constantNode attributeForKey:[IntermediateCodeKeyImp VALUE]] integerValue];
            if ([selectValue integerValue] == constant) {
                return YES;
            }
        }
    }
    return NO;
}

@end
