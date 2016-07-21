//
//  SymbolTableEntry.h
//  Mak
//
//  Created by Alex Restrepo on 6/19/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Definition.h"

@protocol SymbolTable;
@protocol SymbolTableKey;
@protocol TypeSpec;

@protocol SymbolTableEntry <NSObject>

- (NSString *)name;
- (id<SymbolTable>)symbolTable;
- (NSArray *)lineNumbers;
- (void)appendLineNumber:(NSInteger)lineNumber;
- (void)setAttribute:(id)attribute forKey:(id<SymbolTableKey>)key;
- (id)attributeForKey:(id<SymbolTableKey>)key;

- (void)setDefinition:(id<Definition>)definition;
- (id<Definition>)definition;

- (void)setTypeSpec:(id<TypeSpec>)typeSpec;
- (id<TypeSpec>)typeSpec;

@end
