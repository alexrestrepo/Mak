//
//  PascalParserTD.m
//  Mak
//
//  Created by Alex Restrepo on 5/16/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "PascalParserTD.h"

#import <QuartzCore/QuartzCore.h>

#import "Notifications.h"
#import "Token.h"
#import "EofToken.h"
#import "Message.h"
#import "Macros.h"

@implementation PascalParserTD

- (void)parse {
    Token *token = nil;
    NSTimeInterval startTime = CACurrentMediaTime();
    
    while (![(token = [self nextToken]) isKindOfClass:[EofToken class]]) {
        //DebugLog(@"%@", token);
    }
    
    NSTimeInterval elapsedTime = (CACurrentMediaTime() - startTime);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ParserEventNotificationName
                                                        object:[Message messageWithType:MessageTypeParserSummary
                                                                                   body:@[@(token.lineNumber),
                                                                                          @([self errorCount]),
                                                                                          @(elapsedTime)]]];
    
}

- (NSInteger)errorCount {
    return 0;
}

@end
