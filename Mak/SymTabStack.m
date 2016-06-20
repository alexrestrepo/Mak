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
    return [self lookupLocalTable:name];
}

@end
