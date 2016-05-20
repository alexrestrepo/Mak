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

@implementation Executor

- (void)processWithIntermediateCode:(id<IntermediateCode>)intermediateCode table:(id<SymbolTable>)symbolTable {
    NSTimeInterval start = CACurrentMediaTime();
    NSTimeInterval elapsedTime = CACurrentMediaTime() - start;
    NSInteger executionCount = 0;
    NSInteger runtimeErrors = 0;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BackendEventNotificationName
                                                        object:[Message messageWithType:MessageTypeInterpreterSummary
                                                                                   body:@[@(executionCount),
                                                                                          @(runtimeErrors),
                                                                                          @(elapsedTime)]]];
}

@end
