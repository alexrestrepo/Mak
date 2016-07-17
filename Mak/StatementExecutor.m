//
//  StatementExecutor.m
//  Mak
//
//  Created by Alex Restrepo on 6/30/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "StatementExecutor.h"

#import "Message.h"
#import "IntermediateCodeKeyImp.h"
#import "IntermediateCodeNodeTypeImp.h"
#import "CompoundExecutor.h"
#import "AssignmentExecutor.h"
#import "RuntimeErrorCode.h"
#import "LoopExecutor.h"
#import "IfExecutor.h"
#import "SelectExecutor.h"

@implementation StatementExecutor

- (id)executeNode:(id<IntermediateCodeNode>)node {
    id<IntermediateCodeNodeType> nodeType = node.type;
    
    [self sendMessageForNode:node];
    
    if (nodeType == [IntermediateCodeNodeTypeImp COMPOUND]) {
        CompoundExecutor *compoundExecutor = [[CompoundExecutor alloc] initWithParentExecutor:self];
        return [compoundExecutor executeNode:node];
        
    } else if (nodeType == [IntermediateCodeNodeTypeImp ASSIGN]) {
        AssignmentExecutor *assignmentExecutor = [[AssignmentExecutor alloc] initWithParentExecutor:self];
        return [assignmentExecutor executeNode:node];
        
    } else if (nodeType == [IntermediateCodeNodeTypeImp LOOP]) {
        LoopExecutor *loopExecutor = [[LoopExecutor alloc] initWithParentExecutor:self];
        return [loopExecutor executeNode:node];
        
    } else if (nodeType == [IntermediateCodeNodeTypeImp IF]) {
        IfExecutor *ifExecutor = [[IfExecutor alloc] initWithParentExecutor:self];
        return [ifExecutor executeNode:node];
        
    } else if (nodeType == [IntermediateCodeNodeTypeImp SELECT]) {
        SelectExecutor *selectExecutor = [[SelectExecutor alloc] initWithParentExecutor:self];
        return [selectExecutor executeNode:node];
        
    } else if (nodeType == [IntermediateCodeNodeTypeImp NO_OP]) {
        // noop :P
        
    } else {
        [self.errorHandler flagNode:node withErrorCode:[RuntimeErrorCode UNIMPLEMENTED_FEATURE]];
    }
    
    return nil;
}

- (void)sendMessageForNode:(id<IntermediateCodeNode>)node {
    id lineNumber = [node attributeForKey:[IntermediateCodeKeyImp LINE]];
    
    if (lineNumber) {
        [[NSNotificationCenter defaultCenter] postNotificationName:BackendEventNotificationName
                                                            object:[Message messageWithType:MessageTypeSourceLine
                                                                                       body:@[lineNumber, @""]]];
    }
}

@end
