//
//  RuntimeErrorHandler.m
//  Mak
//
//  Created by Alex Restrepo on 6/30/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "RuntimeErrorHandler.h"

#import "Message.h"
#import "IntermediateCodeKeyImp.h"

static const NSInteger MaxErrors = 5;

@interface RuntimeErrorHandler()

@property (nonatomic, assign) NSInteger errorCount;

@end

@implementation RuntimeErrorHandler

- (void)flagNode:(id<IntermediateCodeNode>)node withErrorCode:(RuntimeErrorCode *)errorCode {
    while (node && ![node attributeForKey:[IntermediateCodeKeyImp LINE]]) {
        node = [node parentNode];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BackendEventNotificationName
                                                        object:[Message messageWithType:MessageTypeRuntimeError
                                                                                   body:@[
                                                                                          [errorCode description],
                                                                                          [node attributeForKey:[IntermediateCodeKeyImp LINE]],
                                                                                          ]]];
    
    if (++_errorCount > MaxErrors) {
        printf("*** Aborted after too many runtime errors. ***\n");
        exit(-1);
    }
    
}

@end
