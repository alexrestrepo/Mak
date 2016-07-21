//
//  DeclarationsParser.m
//  Mak
//
//  Created by Alex Restrepo on 7/22/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "DeclarationsParser.h"

#import "PascalTokenType.h"
#import "ConstantDefinitionsParser.h"
#import "TypeDefinitionsParser.h"
#import "VariableDeclarationsParser.h"
#import "DefinitionImpl.h"

static NSSet <id<TokenType>> *DeclarationStartSet;
static NSSet <id<TokenType>> *TypeStartSet;
static NSSet <id<TokenType>> *VarStartSet;
static NSSet <id<TokenType>> *RoutineStartSet;

@implementation DeclarationsParser

+ (void)initialize {
    if (self == [DeclarationsParser class]) {
        DeclarationStartSet = [NSSet setWithArray:@[
                                                    [PascalTokenType CONST],
                                                    [PascalTokenType TYPE],
                                                    [PascalTokenType VAR],
                                                    [PascalTokenType PROCEDURE],
                                                    [PascalTokenType FUNCTION],
                                                    [PascalTokenType BEGIN],
                                                    ]];
        
        NSMutableSet *set = [DeclarationStartSet mutableCopy];
        
        [set removeObject:[PascalTokenType CONST]];
        TypeStartSet = [set copy];
        
        [set removeObject:[PascalTokenType TYPE]];
        VarStartSet = [set copy];
        
        [set removeObject:[PascalTokenType VAR]];
        RoutineStartSet = [set copy];
    }
}

+ (NSSet<id<TokenType>> *)typeStartSet {
    return TypeStartSet;
}

+ (NSSet<id<TokenType>> *)varStartSet {
    return VarStartSet;
}

+ (NSSet<id<TokenType>> *)routineStartSet {
    return RoutineStartSet;
}

- (void)parseToken:(Token *)token {
    token = [self synchronizeWithSet:DeclarationStartSet];
    
    if (token.type == [PascalTokenType CONST]) {
        token = [self nextToken]; // consume
        
        ConstantDefinitionsParser *constanDefinitionParser = [[ConstantDefinitionsParser alloc] initWithParent:self];
        [constanDefinitionParser parseToken:token];        
    }
    
    token = [self synchronizeWithSet:TypeStartSet];
    if (token.type == [PascalTokenType TYPE]) {
        token = [self nextToken];
        
        TypeDefinitionsParser *typeDefinitionsParser = [[TypeDefinitionsParser alloc] initWithParent:self];
        [typeDefinitionsParser parseToken:token];
    }
    
    token = [self synchronizeWithSet:VarStartSet];
    if (token.type == [PascalTokenType VAR]) {
        token = [self nextToken];
        
        VariableDeclarationsParser *variableDeclarationsParser = [[VariableDeclarationsParser alloc] initWithParent:self];
        [variableDeclarationsParser setDefinition:[DefinitionImpl VARIABLE]];
        [variableDeclarationsParser parseToken:token];
    }
    
    token = [self synchronizeWithSet:RoutineStartSet];
}

@end
