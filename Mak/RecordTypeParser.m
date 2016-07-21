//
//  RecordTypeParser.m
//  Mak
//
//  Created by Alex Restrepo on 7/27/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "RecordTypeParser.h"

#import "PascalTokenType.h"
#import "DeclarationsParser.h"
#import "TypeFactory.h"
#import "TypeFormImpl.h"
#import "TypeKeyImpl.h"
#import "VariableDeclarationsParser.h"
#import "DefinitionImpl.h"

static NSSet <id<TokenType>> *EndSet;

@implementation RecordTypeParser

+ (void)initialize {
    if (self == [RecordTypeParser class]) {
        NSMutableSet *set = [[DeclarationsParser varStartSet] mutableCopy];
        [set addObject:[PascalTokenType END]];
        [set addObject:[PascalTokenType SEMICOLON]];
        EndSet = [set copy];
    }
}

- (id<TypeSpec>)parseToken:(Token *)token {
    id<TypeSpec> recordType = [TypeFactory typeWithForm:[TypeFormImpl RECORD]];
    token = [self nextToken];// consume record
    
    [recordType setAttribute:[self.symbolTableStack push] forKey:[TypeKeyImpl RECORD_SYMTAB]];
    
    VariableDeclarationsParser *vdp = [[VariableDeclarationsParser alloc] initWithParent:self];
    [vdp setDefinition:[DefinitionImpl FIELD]];
    [vdp parseToken:token];
    
    [self.symbolTableStack pop];
    
    token = [self synchronizeWithSet:EndSet];
    if (token.type == [PascalTokenType END]) {
        token = [self nextToken];
    } else {
        [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode MISSING_END]];
    }
    
    return recordType;
}

@end
