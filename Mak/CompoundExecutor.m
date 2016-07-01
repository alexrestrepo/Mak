//
//  CompoundExecutor.m
//  Mak
//
//  Created by Alex Restrepo on 6/30/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "CompoundExecutor.h"

@implementation CompoundExecutor

- (id)executeNode:(id<IntermediateCodeNode>)node {
    StatementExecutor *executor = [[StatementExecutor alloc] initWithParentExecutor:self];
    NSArray <id<IntermediateCodeNode>> *children = [node children];
    [children enumerateObjectsUsingBlock:^(id<IntermediateCodeNode>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [executor executeNode:obj];
    }];
    
    return nil;
}

@end
