//
//  PascalParserTD.m
//  Mak
//
//  Created by Alex Restrepo on 5/16/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "PascalParserTD.h"

#import <QuartzCore/QuartzCore.h>

#import "BlockParser.h"
#import "DefinitionImpl.h"
#import "EofToken.h"
#import "IntermediateCodeFactory.h"
#import "Macros.h"
#import "Message.h"
#import "Notifications.h"
#import "PascalTokenType.h"
#import "Predefined.h"
#import "StatementParser.h"
#import "SymTabKey.h"
#import "SymbolTableFactory.h"
#import "Token.h"

static PascalErrorHandler *ErrorHandler;

@interface PascalParserTD()

@property (nonatomic, strong) id<SymbolTableEntry> routineId;

@end

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
    NSTimeInterval startTime = CACurrentMediaTime();
    
    self.intermediateCode = [IntermediateCodeFactory intermediateCode];
    [Predefined initializeWithSymbolTableStack:self.symbolTableStack];
    
    _routineId = [self.symbolTableStack addEntryToLocalTable:@"dummyprogramname"];
    [_routineId setDefinition:[DefinitionImpl PROGRAM]];
    [self.symbolTableStack setProgramIdEntry:_routineId];
    
    [_routineId setAttribute:[self.symbolTableStack push] forKey:[SymTabKey ROUTINE_SYMTAB]];
    [_routineId setAttribute:self.intermediateCode forKey:[SymTabKey ROUTINE_ICODE]];
    
    BlockParser *blockParser = [[BlockParser alloc] initWithParent:self];
    
    Token *token = [self nextToken];
    id<IntermediateCodeNode> rootNode = [blockParser parseToken:token routineEntry:_routineId];
    [self.intermediateCode setRootNode:rootNode];
    [self.symbolTableStack pop];
    
    // look for the final .
    token = [self currentToken];
    if (token.type != [PascalTokenType DOT]) {
        [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode MISSING_PERIOD]];
    }
    token = [self currentToken];
    
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
