//
//  SymbolTable.h
//  Mak
//
//  Created by Alex Restrepo on 5/16/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SymbolTableEntry.h"

@protocol SymbolTable <NSObject>

- (NSInteger)nestingLevel;

- (id<SymbolTableEntry>)addEntry:(NSString *)name;
- (id<SymbolTableEntry>)lookup:(NSString *)name;

- (NSArray *)sortedEntries;

@end
