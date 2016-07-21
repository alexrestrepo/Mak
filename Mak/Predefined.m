//
//  Predefined.m
//  Mak
//
//  Created by Alex Restrepo on 7/19/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "Predefined.h"

#import "TypeFactory.h"
#import "TypeFormImpl.h"
#import "DefinitionImpl.h"
#import "SymTabKey.h"
#import "TypeKeyImpl.h"

// Predefined types.
static id<TypeSpec> IntegerType;
static id<TypeSpec> RealType;
static id<TypeSpec> BooleanType;
static id<TypeSpec> CharType;
static id<TypeSpec> UndefinedType;

// Predefined identifiers.
static id<SymbolTableEntry> IntegerId;
static id<SymbolTableEntry> RealId;
static id<SymbolTableEntry> BooleanId;
static id<SymbolTableEntry> CharId;
static id<SymbolTableEntry> FalseId;
static id<SymbolTableEntry> TrueId;

@implementation Predefined

+ (id<TypeSpec>)integerType {
    return IntegerType;
}

+ (id<TypeSpec>)realType {
    return RealType;
}

+ (id<TypeSpec>)booleanType {
    return BooleanType;
}

+ (id<TypeSpec>)charType {
    return CharType;
}

+ (id<TypeSpec>)undefinedType {
    return UndefinedType;
}

// Predefined identifiers.
+ (id<SymbolTableEntry>)integerId {
    return IntegerId;
}

+ (id<SymbolTableEntry>)realId {
    return RealId;
}

+ (id<SymbolTableEntry>)booleanId {
    return BooleanId;
}

+ (id<SymbolTableEntry>)charId {
    return CharId;
}

+ (id<SymbolTableEntry>)falseId {
    return FalseId;
}

+ (id<SymbolTableEntry>)trueId {
    return TrueId;
}

+ (void)initializeWithSymbolTableStack:(id<SymbolTableStack>)stack {
    [self initializeTypesWithSymbolTableStack:stack];
    [self initializeConstantsWithSymbolTableStack:stack];
}

+ (void)initializeTypesWithSymbolTableStack:(id<SymbolTableStack>)stack {
    IntegerType = [TypeFactory typeWithForm:[TypeFormImpl SCALAR]];
    IntegerId = [stack addEntryToLocalTable:@"integer"];    
    [IntegerId setDefinition:[DefinitionImpl TYPE]];
    [IntegerId setTypeSpec:IntegerType];
    [IntegerType setIdentifier:IntegerId];
    
    RealType = [TypeFactory typeWithForm:[TypeFormImpl SCALAR]];
    RealId = [stack addEntryToLocalTable:@"real"];
    [RealId setDefinition:[DefinitionImpl TYPE]];
    [RealId setTypeSpec:RealType];
    [RealType setIdentifier:RealId];
    
    BooleanType = [TypeFactory typeWithForm:[TypeFormImpl ENUMERATION]];
    BooleanId = [stack addEntryToLocalTable:@"boolean"];
    [BooleanId setDefinition:[DefinitionImpl TYPE]];
    [BooleanId setTypeSpec:BooleanType];
    [BooleanType setIdentifier:BooleanId];
    
    CharType = [TypeFactory typeWithForm:[TypeFormImpl SCALAR]];
    CharId = [stack addEntryToLocalTable:@"char"];
    [CharId setDefinition:[DefinitionImpl TYPE]];
    [CharId setTypeSpec:CharType];
    [CharType setIdentifier:CharId];
    
    UndefinedType = [TypeFactory typeWithForm:[TypeFormImpl SCALAR]];
}

+ (void)initializeConstantsWithSymbolTableStack:(id<SymbolTableStack>)stack {
    FalseId = [stack addEntryToLocalTable:@"false"];
    [FalseId setDefinition:[DefinitionImpl ENUMERATION_CONSTANT]];
    [FalseId setTypeSpec:BooleanType];
    [FalseId setAttribute:@0 forKey:[SymTabKey CONSTANT_VALUE]];
    
    TrueId = [stack addEntryToLocalTable:@"true"];
    [TrueId setDefinition:[DefinitionImpl ENUMERATION_CONSTANT]];
    [TrueId setTypeSpec:BooleanType];
    [TrueId setAttribute:@1 forKey:[SymTabKey CONSTANT_VALUE]];
    
    [BooleanType setAttribute:@[FalseId, TrueId] forKey:[TypeKeyImpl ENUMERATION_CONSTANTS]];
}

@end
