//
//  SubrangeTypeParser.m
//  Mak
//
//  Created by Alex Restrepo on 7/27/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "SubrangeTypeParser.h"

#import "TypeFactory.h"
#import "TypeSpecImpl.h"
#import "TypeFormImpl.h"
#import "ConstantDefinitionsParser.h"
#import "PascalTokenType.h"
#import "TypeKeyImpl.h"
#import "Predefined.h"


@implementation SubrangeTypeParser

- (id<TypeSpec>)parseToken:(Token *)token {
    id<TypeSpec> subrangeType = [TypeFactory typeWithForm:[TypeFormImpl SUBRANGE]];
    id minValue = nil;
    id maxValue = nil;
    
    Token *constantToken = token;
    ConstantDefinitionsParser *constantParser = [[ConstantDefinitionsParser alloc] initWithParent:self];
    minValue = [constantParser parseConstantWithToken:token];
    
    id<TypeSpec> minType = (constantToken.type == [PascalTokenType IDENTIFIER]
                            ? [constantParser constantTypeForToken:constantToken]
                            : [constantParser constantTypeForValue:minValue]);
    
    minValue = [self checkValueTypeForToken:constantToken value:minValue type:minType];
    token = [self currentToken];
    BOOL sawDotDot = NO;
    if (token.type == [PascalTokenType DOT_DOT]) {
        token = [self nextToken];
        sawDotDot = YES;
    }
    
    id<TokenType> tokenType = token.type;
    if ([[ConstantDefinitionsParser constantStartSet] containsObject:tokenType]) {
        if (!sawDotDot) {
            [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode MISSING_DOT_DOT]];
        }
        
        token = [self synchronizeWithSet:[ConstantDefinitionsParser constantStartSet]];
        constantToken = token;
        maxValue = [constantParser parseConstantWithToken:token];
        
        id<TypeSpec> maxType = (constantToken.type == [PascalTokenType IDENTIFIER]
                                ? [constantParser constantTypeForToken:constantToken]
                                : [constantParser constantTypeForValue:maxValue]);
        
        maxValue = [self checkValueTypeForToken:token value:maxValue type:maxType];
        if (minType == nil || maxType == nil) {
            [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode INCOMPATIBLE_TYPES]];
            
        } else if (minType != maxType) {
            [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode INVALID_SUBRANGE_TYPE]];
            
        } else if (minValue && maxValue && [minValue integerValue] >= [maxValue integerValue]) {
            [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode MIN_GT_MAX]];
        }
        
    } else {
        [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode INVALID_SUBRANGE_TYPE]];
    }
    
    [subrangeType setAttribute:minType forKey:[TypeKeyImpl SUBRANGE_BASE_TYPE]];
    [subrangeType setAttribute:minValue forKey:[TypeKeyImpl SUBRANGE_MIN_VALUE]];
    [subrangeType setAttribute:maxValue forKey:[TypeKeyImpl SUBRANGE_MAX_VALUE]];
    
    return subrangeType;
}

- (id)checkValueTypeForToken:(Token *)token value:(id)value type:(id<TypeSpec>)type {
    if (!type) {
        return value;
    }
    
    if (type == [Predefined integerType]) {
        return value;
        
    } else if (type == [Predefined charType]) {
        unichar ch = [value characterAtIndex:0];
        return @(ch);
        
    } else if ([type form] == [TypeFormImpl ENUMERATION]) {
        return value;
        
    } else {
        [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode INVALID_SUBRANGE_TYPE]];
        return value;
    }    
}

@end
