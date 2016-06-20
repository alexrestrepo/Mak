//
//  SymbolTableFactory.m
//  Mak
//
//  Created by Alex Restrepo on 6/19/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "SymbolTableFactory.h"

#import "SymTabStack.h"
#import "SymTab.h"
#import "SymTabEntry.h"

@implementation SymbolTableFactory

+ (id<SymbolTableStack>)symbolTableStack {
    return [[SymTabStack alloc] init];
}

+ (id<SymbolTable>)symbolTableWithNestingLevel:(NSInteger)level {
    return [[SymTab alloc] initWithNestingLevel:level];
}

+ (id<SymbolTableEntry>)symbolTableEntryWithName:(NSString *)name symbolTable:(id<SymbolTable>)symbolTable {
    return [[SymTabEntry alloc] initWithName:name symbolTable:symbolTable];
}

@end
