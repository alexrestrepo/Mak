//
//  IntermediateCodeKeyImp.m
//  Mak
//
//  Created by Alex Restrepo on 6/29/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "IntermediateCodeKeyImp.h"

typedef NS_ENUM(NSUInteger, IntermediateCodeKeys) {
    LINE,
    ID,
    VALUE,
};

@implementation IntermediateCodeKeyImp

#define BUILD_ICODEKEY(code) + (instancetype)code {\
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

- (NSString *)description {
    return _name;
}

BUILD_ICODEKEY(LINE);
BUILD_ICODEKEY(ID);
BUILD_ICODEKEY(VALUE);

@end
