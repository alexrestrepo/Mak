//
//  Executor.h
//  Mak
//
//  Created by Alex Restrepo on 5/19/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "Backend.h"

#import "RuntimeErrorHandler.h"

@interface Executor : Backend

@property (nonatomic, assign) NSInteger executionCount;
@property (nonatomic, assign, readonly) RuntimeErrorHandler *errorHandler;

- (instancetype)initWithParentExecutor:(Executor *)parent;

@end
