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
#import "SymbolTableFactory.h"
#import "IntermediateCodeFactory.h"
#import "StatementParser.h"

@interface PascalParserTD ()

@end

@implementation PascalParserTD

- (instancetype)initWithScanner:(Scanner *)scanner {
    self = [super initWithScanner:scanner];
    if (self) {
        _errorHandler = [PascalErrorHandler new];
    }
    return self;
}

- (instancetype)initWithParent:(PascalParserTD *)parent {
    return [self initWithScanner:parent.scanner];
}

- (void)parse {
    self.intermediateCode = [IntermediateCodeFactory intermediateCode];
    NSTimeInterval startTime = CACurrentMediaTime();
    
    Token *token = [self nextToken];
    id<IntermediateCodeNode> rootNode = nil;
    
    if (token.type == [PascalTokenType BEGIN]) {
        StatementParser *statementParser = [[StatementParser alloc] initWithParent:self];
        rootNode = [statementParser parseToken:token];
        token = [self currentToken];
        
    } else {
        [_errorHandler flagToken:token withErrorCode:[PascalErrorCode UNEXPECTED_TOKEN]];
    }
    
    if (token.type != [PascalTokenType DOT]) {
        [_errorHandler flagToken:token withErrorCode:[PascalErrorCode MISSING_PERIOD]];
    }
    
    token = [self currentToken];
    if (rootNode) {
        [self.intermediateCode setRootNode:rootNode];
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
