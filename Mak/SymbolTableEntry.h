//
//  SymbolTableEntry.h
//  Mak
//
//  Created by Alex Restrepo on 6/19/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SymbolTable;
@protocol SymbolTableKey;

@protocol SymbolTableEntry <NSObject>

- (NSString *)name;
- (id<SymbolTable>)symbolTable;
- (NSArray *)lineNumbers;
- (void)appendLineNumber:(NSInteger)lineNumber;
- (void)setAttribute:(id)attribute forKey:(id<SymbolTableKey>)key;
- (id)attributeForKey:(id<SymbolTableKey>)key;

@end
