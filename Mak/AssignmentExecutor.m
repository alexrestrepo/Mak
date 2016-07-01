//
//  AssignmentExecutor.m
//  Mak
//
//  Created by Alex Restrepo on 6/30/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "AssignmentExecutor.h"

#import "ExpressionExecutor.h"
#import "SymTabEntry.h"
#import "IntermediateCodeKeyImp.h"
#import "SymTabKey.h"
#import "Message.h"

@implementation AssignmentExecutor

- (id)executeNode:(id<IntermediateCodeNode>)node {
    NSArray <id<IntermediateCodeNode>> *children = [node children];
    id<IntermediateCodeNode> variable = children[0];
    id<IntermediateCodeNode> expression = children[1];
    
    ExpressionExecutor *executor = [[ExpressionExecutor alloc] initWithParentExecutor:self];
    id value = [executor executeNode:expression];
    
    SymTabEntry *variableID = [variable attributeForKey:[IntermediateCodeKeyImp ID]];
    [variableID setAttribute:value forKey:[SymTabKey DATA_VALUE]];
 
    [self sendMessageForNode:node name:variableID.name value:value];
    
    self.executionCount++;
    return nil;
}

- (void)sendMessageForNode:(id<IntermediateCodeNode>)node name:(NSString *)name value:(id)value {
    id lineNumber = [node attributeForKey:[IntermediateCodeKeyImp LINE]];
    
    if (lineNumber) {
        [[NSNotificationCenter defaultCenter] postNotificationName:BackendEventNotificationName
                                                            object:[Message messageWithType:MessageTypeAssign
                                                                                       body:@[lineNumber,
                                                                                              name,
                                                                                              value]]];
    }
}

@end
