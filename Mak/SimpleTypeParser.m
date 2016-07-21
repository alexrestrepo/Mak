//
//  SimpleTypeParser.m
//  Mak
//
//  Created by Alex Restrepo on 7/27/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "SimpleTypeParser.h"

#import "PascalTokenType.h"
#import "ConstantDefinitionsParser.h"
#import "SymTabEntry.h"
#import "DefinitionImpl.h"
#import "SubrangeTypeParser.h"
#import "EnumerationTypeParser.h"

static NSSet <id<TokenType>> *SimpleTypeStartSet;

@implementation SimpleTypeParser

+ (void)initialize {
    if (self == [SimpleTypeParser class]) {
        NSMutableSet *workingSet = [[ConstantDefinitionsParser constantStartSet] mutableCopy];
        [workingSet addObject:[PascalTokenType LEFT_PAREN]];
        [workingSet addObject:[PascalTokenType COMMA]];
        [workingSet addObject:[PascalTokenType SEMICOLON]];
        
        SimpleTypeStartSet = [workingSet copy];
    }
}

+ (NSSet <id<TokenType>> *)simpleTypeStartSet {
    return SimpleTypeStartSet;
}

- (id<TypeSpec>)parseToken:(Token *)token {
    token = [self synchronizeWithSet:SimpleTypeStartSet];
    
    if (token.type == [PascalTokenType IDENTIFIER]) {
        NSString *name = [token.text lowercaseString];
        SymTabEntry *identifier = [self.symbolTableStack lookup:name];
        
        if (identifier) {
            id<Definition> definition = identifier.definition;
            if (definition == [DefinitionImpl TYPE]) {
                [identifier appendLineNumber:token.lineNumber];
                token = [self nextToken];
                return identifier.typeSpec;
                
            } else if (definition != [DefinitionImpl CONSTANT] && definition != [DefinitionImpl ENUMERATION_CONSTANT]) {
                [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode NOT_TYPE_IDENTIFIER]];
                token = [self nextToken];
                return nil;
                
            } else {
                SubrangeTypeParser *subrangeTypeParser = [[SubrangeTypeParser alloc] initWithParent:self];
                return [subrangeTypeParser parseToken:token];
            }
            
        } else {
            [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode IDENTIFIER_UNDEFINED]];
            token = [self nextToken];
            return nil;
        }
    } else if (token.type == [PascalTokenType LEFT_PAREN]) {
        EnumerationTypeParser *enumerationTypeParser = [[EnumerationTypeParser alloc] initWithParent:self];
        return [enumerationTypeParser parseToken:token];
        
    } else if (token.type == [PascalTokenType COMMA] || token.type == [PascalTokenType SEMICOLON]) {
        [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode INVALID_TYPE]];
        return nil;
        
    } else {
        SubrangeTypeParser *subrangeTypeParser = [[SubrangeTypeParser alloc] initWithParent:self];
        return [subrangeTypeParser parseToken:token];
    }
    return nil;
}

@end
