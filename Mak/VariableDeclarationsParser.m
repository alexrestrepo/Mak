//
//  VariableDeclarationsParser.m
//  Mak
//
//  Created by Alex Restrepo on 7/24/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "VariableDeclarationsParser.h"

#import "PascalTokenType.h"
#import "DeclarationsParser.h"
#import "TypeSpecificationParser.h"

static NSSet <id<TokenType>> *IdentifierSet;
static NSSet <id<TokenType>> *NextStartSet;

static NSSet <id<TokenType>> *IdentifierStartSet;
static NSSet <id<TokenType>> *IdentifierFollowSet;
static NSSet <id<TokenType>> *CommaSet;

static NSSet <id<TokenType>> *ColonSet;

@implementation VariableDeclarationsParser

+ (void)initialize {
    if (self == [VariableDeclarationsParser class]) {
        NSMutableSet *set = [[DeclarationsParser varStartSet] mutableCopy];
        [set addObject:[PascalTokenType IDENTIFIER]];
        [set addObject:[PascalTokenType END]];
        [set addObject:[PascalTokenType SEMICOLON]];
        IdentifierSet = [set copy];
        
        set = [[DeclarationsParser routineStartSet] mutableCopy];
        [set addObject:[PascalTokenType IDENTIFIER]];
        [set addObject:[PascalTokenType SEMICOLON]];
        NextStartSet = [set copy];

        set = [NSMutableSet setWithArray:@[
                                           [PascalTokenType COLON],
                                           [PascalTokenType SEMICOLON],
                                           ]];
        [set addObjectsFromArray:[[DeclarationsParser varStartSet] allObjects]];
        IdentifierFollowSet = [set copy];

        IdentifierStartSet = [NSMutableSet setWithArray:@[
                                                          [PascalTokenType IDENTIFIER],
                                                          [PascalTokenType COMMA],
                                                          ]];
        
        CommaSet = [NSSet setWithArray:@[
                                         [PascalTokenType COMMA],
                                         [PascalTokenType COLON],
                                         [PascalTokenType IDENTIFIER],
                                         [PascalTokenType SEMICOLON],
                                         ]];
        
        ColonSet = [NSMutableSet setWithArray:@[
                                                [PascalTokenType COLON],
                                                [PascalTokenType SEMICOLON],
                                                ]];
    }
}

- (void)parseToken:(Token *)token {
    token = [self synchronizeWithSet:IdentifierSet];
    
    while (token.type == [PascalTokenType IDENTIFIER]) {
        [self parseIdentifierSublistWithToken:token];
        
        token = [self currentToken];
        id<TokenType> tokenType = token.type;
        
        if (tokenType == [PascalTokenType SEMICOLON]) {
            while (token.type == [PascalTokenType SEMICOLON]) {
                token = [self nextToken];
            }
        } else if ([NextStartSet containsObject:tokenType]) {
            [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode MISSING_SEMICOLON]];
        }
        
        token = [self synchronizeWithSet:IdentifierSet];
    }
}

- (NSArray <id<SymbolTableEntry>> *)parseIdentifierSublistWithToken:(Token *)token {
    NSMutableArray <id<SymbolTableEntry>> *sublist = [NSMutableArray new];
    do {
        token = [self synchronizeWithSet:IdentifierStartSet];
        id<SymbolTableEntry> identifier = [self parseIdentifierWithToken:token];
        if (identifier) {
            [sublist addObject:identifier];
        }
        
        token = [self synchronizeWithSet:CommaSet];
        id<TokenType> tokenType = token.type;
        if (tokenType == [PascalTokenType COMMA]) {
            token = [self nextToken];
            if ([IdentifierFollowSet containsObject:token.type]) {
                [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode MISSING_IDENTIFIER]];
            }
        } else if ([IdentifierStartSet containsObject:tokenType]) {
            [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode MISSING_COMMA]];
        }
        
    } while (![IdentifierFollowSet containsObject:token.type]);
    
    id<TypeSpec> type = [self parseTypeSpecWithToken:token];
    for (id<SymbolTableEntry> variableId in sublist) {
        [variableId setTypeSpec:type];
    }
    
    return sublist;
}

- (id<SymbolTableEntry>)parseIdentifierWithToken:(Token *)token {
    id<SymbolTableEntry> identifier = nil;
    if (token.type == [PascalTokenType IDENTIFIER]) {
        NSString *name = [token.text lowercaseString];
        identifier = [self.symbolTableStack lookupLocalTable:name];
        
        if (identifier) {
            [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode IDENTIFIER_REDEFINED]];
        } else {
            identifier = [self.symbolTableStack addEntryToLocalTable:name];
            [identifier setDefinition:_definition];
            [identifier appendLineNumber:token.lineNumber];
        }
        
        token = [self nextToken];
        
    } else {
        [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode MISSING_IDENTIFIER]];
        
    }
    return identifier;
}

- (id<TypeSpec>)parseTypeSpecWithToken:(Token *)token {
    token = [self synchronizeWithSet:ColonSet];
    if (token.type == [PascalTokenType COLON]) {
        token = [self nextToken];
        
    } else {
        [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode MISSING_COLON]];
    }
    
    TypeSpecificationParser *tsp = [[TypeSpecificationParser alloc] initWithParent:self];
    id<TypeSpec> type = [tsp parseToken:token];
    
    return type;
}

@end
