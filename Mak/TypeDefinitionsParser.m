//
//  TypeDefinitionsParser.m
//  Mak
//
//  Created by Alex Restrepo on 7/24/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "TypeDefinitionsParser.h"

#import "PascalTokenType.h"
#import "ConstantDefinitionsParser.h"
#import "SymTabEntry.h"
#import "TypeSpecificationParser.h"
#import "DefinitionImpl.h"

static NSSet <id<TokenType>> *IdentifierSet;
static NSSet <id<TokenType>> *EqualsSet;
static NSSet <id<TokenType>> *FollowSet;
static NSSet <id<TokenType>> *NextStartSet;

@implementation TypeDefinitionsParser

+ (void)initialize {
    if (self == [TypeDefinitionsParser class]) {
        NSMutableSet *workingSet = [[DeclarationsParser varStartSet] mutableCopy];
        [workingSet addObject:[PascalTokenType IDENTIFIER]];
        
        IdentifierSet = [workingSet copy];
        
        workingSet = [[ConstantDefinitionsParser constantStartSet] mutableCopy];
        [workingSet addObject:[PascalTokenType EQUALS]];
        [workingSet addObject:[PascalTokenType SEMICOLON]];
        EqualsSet = [workingSet copy];
        
        FollowSet = [NSSet setWithObject:[PascalTokenType SEMICOLON]];
        
        workingSet = [[DeclarationsParser varStartSet] mutableCopy];
        [workingSet addObject:[PascalTokenType SEMICOLON]];
        [workingSet addObject:[PascalTokenType IDENTIFIER]];
        NextStartSet = [workingSet copy];
    }
}

- (void)parseToken:(Token *)token {
    token = [self synchronizeWithSet:IdentifierSet];
    
    while (token.type == [PascalTokenType IDENTIFIER]) {
        NSString *name = [token.text lowercaseString];
        SymTabEntry *typeId = [self.symbolTableStack lookupLocalTable:name];
        
        if (!typeId) {
            typeId = [self.symbolTableStack addEntryToLocalTable:name];
            [typeId appendLineNumber:token.lineNumber];
            
        } else {
            [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode IDENTIFIER_REDEFINED]];
            typeId = nil;
        }
        
        token = [self nextToken];
        token = [self synchronizeWithSet:EqualsSet];
        
        if (token.type == [PascalTokenType EQUALS]) {
            token = [self nextToken];
        } else {
            [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode MISSING_EQUALS]];
        }
        
        TypeSpecificationParser *typeSpecificationParser = [[TypeSpecificationParser alloc] initWithParent:self];
        id<TypeSpec> type = [typeSpecificationParser parseToken:token];
        
        if (typeId) {
            [typeId setDefinition:[DefinitionImpl TYPE]];
        }
        
        if (type && typeId) {
            if (![type identifier]) {
                [type setIdentifier:typeId];
            }
            [typeId setTypeSpec:type];
            
        } else {
            token = [self synchronizeWithSet:FollowSet];
        }
        
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

@end
