//
//  SymbolTableStack.h
//  Mak
//
//  Created by Alex Restrepo on 6/19/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SymbolTable.h"

@protocol SymbolTableStack <NSObject>

- (NSInteger)currentNestingLevel;
- (id<SymbolTable>)localSymbolTable;

- (id<SymbolTableEntry>)addEntryToLocalTable:(NSString *)name;
- (id<SymbolTableEntry>)lookupLocalTable:(NSString *)name;
- (id<SymbolTableEntry>)lookup:(NSString *)name;

- (void)setProgramIdEntry:(id<SymbolTableEntry>)entry;
- (id<SymbolTableEntry>)programIdEntry;

- (id<SymbolTable>)push;
- (id<SymbolTable>)push:(id<SymbolTable>)table;
- (id<SymbolTable>)pop;

@end
