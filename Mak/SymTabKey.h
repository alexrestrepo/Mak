//
//  SymTabKey.h
//  Mak
//
//  Created by Alex Restrepo on 6/19/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SymbolTableKey.h"

@interface SymTabKey : NSObject <SymbolTableKey>

@property (nonatomic, assign, readonly) NSInteger ordinal;

+ (instancetype)CONSTANT_VALUE;
+ (instancetype)ROUTINE_CODE;
+ (instancetype)ROUTINE_SYMTAB;
+ (instancetype)ROUTINE_ICODE;
+ (instancetype)ROUTINE_PARAMS;
+ (instancetype)ROUTINE_ROUTINES;
+ (instancetype)DATA_VALUE;

@end
