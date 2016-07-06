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

static PascalErrorHandler *ErrorHandler;


@implementation PascalParserTD

+ (void)initialize {
    if (self == [PascalParserTD class]) {
        ErrorHandler = [PascalErrorHandler new];
    }
}

- (instancetype)initWithParent:(PascalParserTD *)parent {
    return [super initWithScanner:parent.scanner];
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
        [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode UNEXPECTED_TOKEN]];
    }
    
    if (token.type != [PascalTokenType DOT]) {
        [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode MISSING_PERIOD]];
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

- (PascalErrorHandler *)errorHandler {
    return ErrorHandler;
}

- (NSInteger)errorCount {
    return self.errorHandler.errorCount;
}

- (Token *)synchronizeWithSet:(NSSet <id<TokenType>> *)syncSet {
    Token *token = [self currentToken];
    if (![syncSet containsObject:token.type]) {
        [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode UNEXPECTED_TOKEN]];
        
        do {
            token = [self nextToken];
            
        } while (![token isKindOfClass:[EofToken class]]
                 && ![syncSet containsObject:token.type]);
    }
    
    return token;
}

@end
