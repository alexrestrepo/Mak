//
//  EnumerationTypeParser.m
//  Mak
//
//  Created by Alex Restrepo on 7/27/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "EnumerationTypeParser.h"

#import "PascalTokenType.h"
#import "DeclarationsParser.h"
#import "TypeSpecImpl.h"
#import "TypeFactory.h"
#import "TypeFormImpl.h"
#import "TypeKeyImpl.h"
#import "SymTabEntry.h"
#import "DefinitionImpl.h"
#import "SymTabKey.h"

static NSSet <id<TokenType>> *EnumConstantStartSet;
static NSSet <id<TokenType>> *EnumDefinitionFollowSet;

@implementation EnumerationTypeParser

+ (void)initialize {
    if (self == [EnumerationTypeParser class]) {
        EnumConstantStartSet = [NSSet setWithArray:@[
                                                     [PascalTokenType IDENTIFIER],
                                                     [PascalTokenType COMMA]
                                                     ]];
        
        NSMutableSet *set = [NSMutableSet new];
        [set addObject:[PascalTokenType RIGHT_PAREN]];
        [set addObject:[PascalTokenType SEMICOLON]];
        [set addObjectsFromArray:[[DeclarationsParser varStartSet] allObjects]];
        EnumDefinitionFollowSet = [set copy];
    }
}

- (id<TypeSpec>)parseToken:(Token *)token {
    id<TypeSpec> enumerationType = [TypeFactory typeWithForm:[TypeFormImpl ENUMERATION]];
    NSInteger value = -1;
    NSMutableArray <id<SymbolTableEntry>> *constants = [NSMutableArray new];
    
    token = [self nextToken]; // consume (
    do {
        token = [self synchronizeWithSet:EnumConstantStartSet];
        [self parseEnumerationIdentifierWithToken:token value:++value type:enumerationType storage:constants];
        
        token = [self currentToken];
        id<TokenType> tokenType = token.type;
        if (tokenType == [PascalTokenType COMMA]) {
            token = [self nextToken];
            if ([EnumDefinitionFollowSet containsObject:token.type]) {
                [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode MISSING_IDENTIFIER]];
            }
            
        } else if ([EnumConstantStartSet containsObject:tokenType]) {
            [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode MISSING_COMMA]];
        }
        
    } while (![EnumDefinitionFollowSet containsObject:token.type]);
    
    if (token.type == [PascalTokenType RIGHT_PAREN]) {
        token = [self nextToken];
        
    } else {
        [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode MISSING_RIGHT_PAREN]];
    }
    
    [enumerationType setAttribute:constants forKey:[TypeKeyImpl ENUMERATION_CONSTANTS]];
    return enumerationType;
}

- (void)parseEnumerationIdentifierWithToken:(Token *)token
                                      value:(NSInteger)value
                                       type:(id<TypeSpec>)type
                                    storage:(NSMutableArray<id<SymbolTableEntry>> *)constants {
    id<TokenType> tokenType = token.type;
    if (tokenType == [PascalTokenType IDENTIFIER]) {
        NSString *name = [token.text lowercaseString];
        SymTabEntry *constantId = [self.symbolTableStack lookupLocalTable:name];
        
        if (constantId) {
            [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode IDENTIFIER_REDEFINED]];
            
        } else {
            constantId = [self.symbolTableStack addEntryToLocalTable:token.text];
            [constantId setDefinition:[DefinitionImpl ENUMERATION_CONSTANT]];
            [constantId setTypeSpec:type];
            [constantId setAttribute:@(value) forKey:[SymTabKey CONSTANT_VALUE]];
            [constantId appendLineNumber:token.lineNumber];
            [constants addObject:constantId];
        }
        
        token = [self nextToken];
        
    } else {
        [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode MISSING_IDENTIFIER]];
    }        
}

@end
