//
//  Predefined.h
//  Mak
//
//  Created by Alex Restrepo on 7/19/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SymbolTableStack.h"

@interface Predefined : NSObject

// Predefined types.
+ (id<TypeSpec>)integerType;
+ (id<TypeSpec>)realType;
+ (id<TypeSpec>)booleanType;
+ (id<TypeSpec>)charType;
+ (id<TypeSpec>)undefinedType;

// Predefined identifiers.
+ (id<SymbolTableEntry>)integerId;
+ (id<SymbolTableEntry>)realId;
+ (id<SymbolTableEntry>)booleanId;
+ (id<SymbolTableEntry>)charId;
+ (id<SymbolTableEntry>)falseId;
+ (id<SymbolTableEntry>)trueId;

+ (void)initializeWithSymbolTableStack:(id<SymbolTableStack>)stack;

@end
