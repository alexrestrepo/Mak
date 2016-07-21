//
//  ArrayTypeParser.m
//  Mak
//
//  Created by Alex Restrepo on 7/27/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "ArrayTypeParser.h"

#import "PascalTokenType.h"
#import "SimpleTypeParser.h"
#import "TypeSpecificationParser.h"
#import "TypeFactory.h"
#import "TypeFormImpl.h"
#import "TypeKeyImpl.h"

static NSSet <id<TokenType>> *LeftBracketSet;
static NSSet <id<TokenType>> *RightBracketSet;
static NSSet <id<TokenType>> *OfSet;

static NSSet <id<TokenType>> *IndexStartSet;
static NSSet <id<TokenType>> *IndexEndSet;
static NSSet <id<TokenType>> *IndexFollowSet;

@implementation ArrayTypeParser

+ (void)initialize {
    if (self == [ArrayTypeParser class]) {
        NSMutableSet *set = [[SimpleTypeParser simpleTypeStartSet] mutableCopy];
        [set addObject:[PascalTokenType LEFT_BRACKET]];
        [set addObject:[PascalTokenType RIGHT_BRACKET]];
        LeftBracketSet = [set copy];
        
        RightBracketSet = [NSSet setWithArray:@[
                                                [PascalTokenType RIGHT_BRACKET],
                                                [PascalTokenType OF],
                                                [PascalTokenType SEMICOLON],
                                                ]];
        
        set = [[TypeSpecificationParser typeStartSet] mutableCopy];
        [set addObject:[PascalTokenType OF]];
        [set addObject:[PascalTokenType SEMICOLON]];
        OfSet = [set copy];
        
        set = [[SimpleTypeParser simpleTypeStartSet] mutableCopy];
        [set addObject:[PascalTokenType COMMA]];
        IndexStartSet = [set copy];
        
        IndexEndSet = [NSSet setWithArray:@[
                                            [PascalTokenType RIGHT_BRACKET],
                                            [PascalTokenType OF],
                                            [PascalTokenType SEMICOLON],
                                            ]];
        
        set = [IndexStartSet mutableCopy];
        [set addObjectsFromArray:[IndexEndSet allObjects]];
        IndexFollowSet = [set copy];
    }
}

- (id<TypeSpec>)parseToken:(Token *)token {
    id<TypeSpec> arrayType = [TypeFactory typeWithForm:[TypeFormImpl ARRAY]];
    token = [self nextToken]; // consume ARRAY
    
    token = [self synchronizeWithSet:LeftBracketSet];
    if (token.type != [PascalTokenType LEFT_BRACKET]) {
        [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode MISSING_LEFT_BRACKET]];
    }
    
    id<TypeSpec> elementType = [self parseIndexTypeListWithToken:token type:arrayType];
    token = [self synchronizeWithSet:RightBracketSet];
    if (token.type == [PascalTokenType RIGHT_BRACKET]) {
        token = [self nextToken]; // consume ]
        
    } else {
        [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode MISSING_RIGHT_BRACKET]];
    }
    
    token = [self synchronizeWithSet:OfSet];
    if (token.type == [PascalTokenType OF]) {
        token = [self nextToken];
    } else {
        [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode MISSING_OF]];
    }
    
    [elementType setAttribute:[self parseElementTypeWithToken:token] forKey:[TypeKeyImpl ARRAY_ELEMENT_TYPE]];
    return arrayType;
}

- (id<TypeSpec>)parseIndexTypeListWithToken:(Token *)token type:(id<TypeSpec>)type {
    id<TypeSpec> elementType = type;
    BOOL anotherIndex = NO;
    
    token = [self nextToken]; // consume [
    do {
        anotherIndex = NO;
        token = [self synchronizeWithSet:IndexStartSet];
        [self parseIndexTypeWithToken:token type:elementType];
        
        token = [self synchronizeWithSet:IndexFollowSet];
        id<TokenType> tokenType = token.type;
        
        if (tokenType != [PascalTokenType COMMA] && tokenType != [PascalTokenType RIGHT_BRACKET]) {
            if ([IndexStartSet containsObject:tokenType]) {
                [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode MISSING_COMMA]];
                anotherIndex = YES;
            }
        } else if (tokenType == [PascalTokenType COMMA]) {
            id<TypeSpec> newElementType = [TypeFactory typeWithForm:[TypeFormImpl ARRAY]];
            [elementType setAttribute:newElementType forKey:[TypeKeyImpl ARRAY_ELEMENT_TYPE]];
            elementType = newElementType;
            
            token = [self nextToken]; // consume ,
            anotherIndex = YES;
        }
        
    } while (anotherIndex);
    
    return elementType;
}

- (void)parseIndexTypeWithToken:(Token *)token type:(id<TypeSpec>)type {
    SimpleTypeParser *simpleTypeParser = [[SimpleTypeParser alloc] initWithParent:self];
    id<TypeSpec> indexType = [simpleTypeParser parseToken:token];
    [type setAttribute:indexType forKey:[TypeKeyImpl ARRAY_INDEX_TYPE]];
    
    if (!indexType) {
        return;
    }
    
    id<TypeForm> form = [indexType form];
    NSInteger count = 0;
    if (form == [TypeFormImpl SUBRANGE]) {
        NSInteger minValue = [[indexType attributeForKey:[TypeKeyImpl SUBRANGE_MIN_VALUE]] integerValue];
        NSInteger maxValue = [[indexType attributeForKey:[TypeKeyImpl SUBRANGE_MAX_VALUE]] integerValue];
        
        count = maxValue - minValue + 1;
        
    } else if (form == [TypeFormImpl ENUMERATION]) {
        NSArray <id<SymbolTableEntry>> *constants = [indexType attributeForKey:[TypeKeyImpl ENUMERATION_CONSTANTS]];
        count = [constants count];
        
    } else {
        [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode INVALID_INDEX_TYPE]];
    }
    
    [type setAttribute:@(count) forKey:[TypeKeyImpl ARRAY_ELEMENT_COUNT]];
}

- (id<TypeSpec>)parseElementTypeWithToken:(Token *)token {
    TypeSpecificationParser *tsp = [[TypeSpecificationParser alloc] initWithParent:self];
    return [tsp parseToken:token];
}

@end
