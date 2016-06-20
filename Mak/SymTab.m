//
//  SymTab.m
//  Mak
//
//  Created by Alex Restrepo on 6/19/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "SymTab.h"
#import "SymbolTableFactory.h"

@interface SymTab()

@property (nonatomic, assign) NSInteger nestingLevel;
@property (nonatomic, strong) NSMutableDictionary *entries;

@end

@implementation SymTab

- (instancetype)initWithNestingLevel:(NSInteger)nestingLevel {
    self = [super init];
    if (self) {
        _nestingLevel = nestingLevel;
        _entries = [NSMutableDictionary new];
    }
    return self;
}

- (id<SymbolTableEntry>)addEntry:(NSString *)name {
    id<SymbolTableEntry> entry = [SymbolTableFactory symbolTableEntryWithName:name symbolTable:self];
    _entries[name] = entry;
    
    return entry;
}

- (id<SymbolTableEntry>)lookup:(NSString *)name {
    return _entries[name];
}

- (NSArray *)sortedEntries {
    return [[_entries allValues] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
}

@end
