//
//  TypeKeyImpl.m
//  Mak
//
//  Created by Alex Restrepo on 7/19/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "TypeKeyImpl.h"

typedef NS_ENUM(NSUInteger, TypeKeys) {
    // Enumeration
    ENUMERATION_CONSTANTS,
    
    // Subrange
    SUBRANGE_BASE_TYPE, SUBRANGE_MIN_VALUE, SUBRANGE_MAX_VALUE,
    
    // Array
    ARRAY_INDEX_TYPE, ARRAY_ELEMENT_TYPE, ARRAY_ELEMENT_COUNT,
    
    // Record
    RECORD_SYMTAB
};

@implementation TypeKeyImpl

#define BUILD_TYPEKEY(code) + (instancetype)code {\
    static id this = nil;\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        this = [[self alloc] initWithOrdinal:code name:@#code];\
    });\
    return this;\
}

- (instancetype)initWithOrdinal:(NSInteger)ordinal name:(NSString *)name {
    self = [super init];
    if (self) {
        _ordinal = ordinal;
        _name = name;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

BUILD_TYPEKEY(ENUMERATION_CONSTANTS);
BUILD_TYPEKEY(SUBRANGE_BASE_TYPE);
BUILD_TYPEKEY(SUBRANGE_MIN_VALUE);
BUILD_TYPEKEY(SUBRANGE_MAX_VALUE);
BUILD_TYPEKEY(ARRAY_INDEX_TYPE);
BUILD_TYPEKEY(ARRAY_ELEMENT_TYPE);
BUILD_TYPEKEY(ARRAY_ELEMENT_COUNT);
BUILD_TYPEKEY(RECORD_SYMTAB);

@end
