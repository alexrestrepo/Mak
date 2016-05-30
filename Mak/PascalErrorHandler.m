//
//  PascalErrorHandler.m
//  Mak
//
//  Created by Alex Restrepo on 5/29/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "PascalErrorHandler.h"

#import "Message.h"

static const NSInteger MaxErrors = 25;

@interface PascalErrorHandler ()

@property (nonatomic, assign) NSInteger errorCount;

@end

@implementation PascalErrorHandler

- (void)flagToken:(Token *)token withErrorCode:(PascalErrorCode *)errorCode; {
    [[NSNotificationCenter defaultCenter] postNotificationName:ParserEventNotificationName
                                                        object:[Message messageWithType:MessageTypeSyntaxError
                                                                                   body:@[@(token.lineNumber),
                                                                                          @(token.position),
                                                                                          token.text,
                                                                                          [errorCode description]]]];
    
    if (++_errorCount > MaxErrors) {
        [self abortWithErrorCode:[PascalErrorCode TOO_MANY_ERRORS]];
    }
}

- (void)abortWithErrorCode:(PascalErrorCode *)code {
    NSString *fatalText = [NSString stringWithFormat:@"OMG NOES: %@", code];
    [[NSNotificationCenter defaultCenter] postNotificationName:ParserEventNotificationName
                                                        object:[Message messageWithType:MessageTypeSyntaxError
                                                                                   body:@[@0,
                                                                                          @0,
                                                                                          @"",
                                                                                          fatalText]]];
    
    exit((int)code.status);
}

@end
