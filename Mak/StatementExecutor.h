//
//  StatementExecutor.h
//  Mak
//
//  Created by Alex Restrepo on 6/30/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "Executor.h"

@interface StatementExecutor : Executor

- (id)executeNode:(id<IntermediateCodeNode>)node;

@end
