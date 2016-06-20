//
//  SymbolTableFactory.h
//  Mak
//
//  Created by Alex Restrepo on 6/19/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SymbolTableStack.h"

@interface SymbolTableFactory : NSObject

+ (id<SymbolTableStack>)symbolTableStack;
+ (id<SymbolTable>)symbolTableWithNestingLevel:(NSInteger)level;
+ (id<SymbolTableEntry>)symbolTableEntryWithName:(NSString *)key symbolTable:(id<SymbolTable>)symbolTable;

@end
