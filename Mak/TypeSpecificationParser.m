//
//  TypeSpecificationParser.m
//  Mak
//
//  Created by Alex Restrepo on 7/24/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "TypeSpecificationParser.h"

#import "PascalTokenType.h"
#import "SimpleTypeParser.h"
#import "ArrayTypeParser.h"
#import "RecordTypeParser.h"

static NSSet <id<TokenType>> *TypeStartSet;

@implementation TypeSpecificationParser

+ (void)initialize {
    if (self == [TypeSpecificationParser class]) {
        NSMutableSet *workingSet = [[SimpleTypeParser simpleTypeStartSet] mutableCopy];
        [workingSet addObject:[PascalTokenType ARRAY]];
        [workingSet addObject:[PascalTokenType RECORD]];
        [workingSet addObject:[PascalTokenType SEMICOLON]];
        
        TypeStartSet = [workingSet copy];
    }
}

+ (NSSet<id<TokenType>> *)typeStartSet {
    return TypeStartSet;
}

- (id<TypeSpec>)parseToken:(Token *)token {
    token = [self synchronizeWithSet:TypeStartSet];
    
    if (token.type == [PascalTokenType ARRAY]) {
        ArrayTypeParser *arrayTypeParser = [[ArrayTypeParser alloc] initWithParent:self];
        return [arrayTypeParser parseToken:token];
        
    } else if (token.type == [PascalTokenType RECORD]) {
        RecordTypeParser *recordTypeParser = [[RecordTypeParser alloc] initWithParent:self];
        return [recordTypeParser parseToken:token];
    }
    
    SimpleTypeParser *simpleTypeParser = [[SimpleTypeParser alloc] initWithParent:self];
    return [simpleTypeParser parseToken:token];
}

@end
