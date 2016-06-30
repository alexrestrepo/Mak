//
//  SymTabKey.m
//  Mak
//
//  Created by Alex Restrepo on 6/19/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "SymTabKey.h"

typedef NS_ENUM(NSUInteger, SymbolTableKeys) {
    CONSTANT_VALUE,
    ROUTINE_CODE,
    ROUTINE_SYMTAB,
    ROUTINE_ICODE,
    ROUTINE_PARAMS,
    ROUTINE_ROUTINES,
    DATA_VALUE
};

@implementation SymTabKey

#define BUILD_SYMTABKEY(code) + (instancetype)code {\
    static SymTabKey *thisKey = nil;\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        thisKey = [[SymTabKey alloc] initWithOrdinal:code];\
    });\
    return thisKey;\
}

+ (void)initialize {
    if (self == [SymTabKey class]) {
        [SymTabKey CONSTANT_VALUE];
        [SymTabKey ROUTINE_CODE];
        [SymTabKey ROUTINE_SYMTAB];
        [SymTabKey ROUTINE_ICODE];
        [SymTabKey ROUTINE_PARAMS];
        [SymTabKey ROUTINE_ROUTINES];
        [SymTabKey DATA_VALUE];
    }
}

- (instancetype)initWithOrdinal:(NSInteger)ordinal {
    self = [super init];
    if (self) {
        _ordinal = ordinal;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

BUILD_SYMTABKEY(CONSTANT_VALUE);
BUILD_SYMTABKEY(ROUTINE_CODE);
BUILD_SYMTABKEY(ROUTINE_SYMTAB);
BUILD_SYMTABKEY(ROUTINE_ICODE);
BUILD_SYMTABKEY(ROUTINE_PARAMS);
BUILD_SYMTABKEY(ROUTINE_ROUTINES);
BUILD_SYMTABKEY(DATA_VALUE);

@end
