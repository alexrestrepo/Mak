//
//  Executor.m
//  Mak
//
//  Created by Alex Restrepo on 5/19/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "Executor.h"

#import <QuartzCore/QuartzCore.h>

#import "Notifications.h"
#import "SymbolTable.h"
#import "IntermediateCode.h"
#import "Message.h"
#import "StatementExecutor.h"


static NSInteger ExecutionCount = 0;
static RuntimeErrorHandler *ErrorHandler;

@implementation Executor

+ (void)initialize {
    if (self == [Executor class]) {
        ErrorHandler = [RuntimeErrorHandler new];
    }
}

- (instancetype)initWithParentExecutor:(Executor *)parent {
    return [super init];
}

- (void)processWithIntermediateCode:(id<IntermediateCode>)intermediateCode table:(id<SymbolTableStack>)symbolTableStack {
    self.symbolTableStack = symbolTableStack;
    self.intermediateCode = intermediateCode;
    
    NSTimeInterval start = CACurrentMediaTime();
    id<IntermediateCodeNode> rootNode = [intermediateCode rootNode];
    StatementExecutor *statementExecutor = [[StatementExecutor alloc] initWithParentExecutor:self];
    [statementExecutor executeNode:rootNode];
    
    NSTimeInterval elapsedTime = CACurrentMediaTime() - start;
    NSInteger executionCount = self.executionCount;
    NSInteger runtimeErrors = self.errorHandler.errorCount;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BackendEventNotificationName
                                                        object:[Message messageWithType:MessageTypeInterpreterSummary
                                                                                   body:@[@(executionCount),
                                                                                          @(runtimeErrors),
                                                                                          @(elapsedTime)]]];
}

- (RuntimeErrorHandler *)errorHandler {
    return ErrorHandler;
}

- (NSInteger)executionCount {
    return ExecutionCount;
}

- (void)setExecutionCount:(NSInteger)executionCount {
    ExecutionCount = executionCount;
}

@end
