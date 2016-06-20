//
//  SymTabEntry.m
//  Mak
//
//  Created by Alex Restrepo on 6/19/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "SymTabEntry.h"

#import "SymbolTableKey.h"

@interface SymTabEntry()

@property (nonatomic, copy) NSString *name;
@property (nonatomic, weak) id<SymbolTable> symbolTable;
@property (nonatomic, strong) NSMutableArray *lineNumbers;
@property (nonatomic, strong) NSMutableDictionary *attributes;

@end

@implementation SymTabEntry

- (instancetype)initWithName:(NSString *)name symbolTable:(id<SymbolTable>)symbolTable {
    self = [super init];
    if (self) {
        _name = name;
        _symbolTable = symbolTable;
        _lineNumbers = [NSMutableArray new];
        _attributes = [NSMutableDictionary new];
    }
    return self;
}


- (void)appendLineNumber:(NSInteger)lineNumber {
    [_lineNumbers addObject:@(lineNumber)];
}

- (void)setAttribute:(id)attribute forKey:(id<SymbolTableKey>)key {
    _attributes[key] = attribute;
}

- (id)attributeForKey:(id<SymbolTableKey>)key {
    return _attributes[key];
}

@end
