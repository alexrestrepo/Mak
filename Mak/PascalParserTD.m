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
#import "PascalTokenType.h"
#import "PascalErrorHandler.h"
#import "SymbolTableFactory.h"

@interface PascalParserTD ()
@property (nonatomic, strong) PascalErrorHandler *errorHandler;
@end

@implementation PascalParserTD

- (instancetype)initWithScanner:(Scanner *)scanner {
    self = [super initWithScanner:scanner];
    if (self) {
        _errorHandler = [PascalErrorHandler new];
    }
    return self;
}

- (void)parse {
    Token *token = nil;
    NSTimeInterval startTime = CACurrentMediaTime();
    
    while (![(token = [self nextToken]) isKindOfClass:[EofToken class]]) {
        id<TokenType> tokenType = token.type;
        NSAssert(tokenType, @"No token type??");
        
        if (tokenType == [PascalTokenType IDENTIFIER]) {
            NSString *name = [token.text lowercaseString];
            id<SymbolTableEntry> entry = [[self symbolTableStack] lookup:name];
            if (!entry) {
                entry = [[self symbolTableStack] addEntryToLocalTable:name];
            }
            
            [entry appendLineNumber:token.lineNumber];
            
        } else if (tokenType == [PascalTokenType ERROR]) {
            [_errorHandler flagToken:token withErrorCode:(PascalErrorCode *)token.value];
        }
                        
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
