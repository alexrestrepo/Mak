//
//  SymTabStack.m
//  Mak
//
//  Created by Alex Restrepo on 6/19/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "SymTabStack.h"
#import "SymbolTableFactory.h"

@interface SymTabStack()

@property (nonatomic, assign) NSInteger currentNestingLevel;
@property (nonatomic, strong) NSMutableArray<id <SymbolTable>> *stack;
@property (nonatomic, strong) id<SymbolTableEntry> programId;

@end

@implementation SymTabStack

- (instancetype)init {
    self = [super init];
    if (self) {
        _currentNestingLevel = 0;
        _stack = [NSMutableArray new];
        
        [_stack addObject:[SymbolTableFactory symbolTableWithNestingLevel:_currentNestingLevel]];
    }
    return  self;
}

- (id<SymbolTable>)localSymbolTable {
    return _stack[_currentNestingLevel];
}

- (id<SymbolTableEntry>)addEntryToLocalTable:(NSString *)name {
    return [_stack[_currentNestingLevel] addEntry:name];
}

- (id<SymbolTableEntry>)lookupLocalTable:(NSString *)name {
    return [_stack[_currentNestingLevel] lookup:name];
}

- (id<SymbolTableEntry>)lookup:(NSString *)name {
    id<SymbolTableEntry> entry = nil;
    for (NSInteger i = _currentNestingLevel; (i >= 0) && (!entry); i--) {
        entry = [_stack[i] lookup:name];
    }
    
    return entry;
}

- (void)setProgramIdEntry:(id<SymbolTableEntry>)entry {
    _programId = entry;
}

- (id<SymbolTableEntry>)programIdEntry {
    return _programId;
}

- (id<SymbolTable>)push {
    id<SymbolTable> symTab = [SymbolTableFactory symbolTableWithNestingLevel:++_currentNestingLevel];
    [_stack addObject:symTab];
    
    return symTab;
}

- (id<SymbolTable>)push:(id<SymbolTable>)symTab {
    ++_currentNestingLevel;
    [_stack addObject:symTab];
    
    return symTab;
}

- (id<SymbolTable>)pop {
    id<SymbolTable> symTab = _stack[_currentNestingLevel];
    [_stack removeObjectAtIndex:_currentNestingLevel--];
    
    return symTab;
}

@end
