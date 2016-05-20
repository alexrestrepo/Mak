//
//  CodeGenerator.m
//  Mak
//
//  Created by Alex Restrepo on 5/19/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "CodeGenerator.h"

#import <QuartzCore/QuartzCore.h>

#import "Notifications.h"
#import "SymbolTable.h"
#import "IntermediateCode.h"
#import "Message.h"

@implementation CodeGenerator

- (void)processWithIntermediateCode:(id<IntermediateCode>)intermediateCode table:(id<SymbolTable>)symbolTable {
    NSTimeInterval start = CACurrentMediaTime();
    NSTimeInterval elapsedTime = CACurrentMediaTime() - start;
    NSInteger instructionCount = 0;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BackendEventNotificationName
                                                        object:[Message messageWithType:MessageTypeCompilerSummary
                                                                                   body:@[@(instructionCount), @(elapsedTime)]]];
}

@end
