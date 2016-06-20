//
//  SymTabEntry.h
//  Mak
//
//  Created by Alex Restrepo on 6/19/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SymbolTableEntry.h"

@interface SymTabEntry : NSObject <SymbolTableEntry>

- (instancetype)initWithName:(NSString *)name symbolTable:(id<SymbolTable>)symbolTable;

@end
