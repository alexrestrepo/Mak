//
//  TypeFormImpl.m
//  Mak
//
//  Created by Alex Restrepo on 7/19/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "TypeFormImpl.h"

typedef NS_ENUM(NSUInteger, TypeForms) {
    SCALAR,
    ENUMERATION,
    SUBRANGE,
    ARRAY,
    RECORD,
};

@implementation TypeFormImpl

#define BUILD_TYPEFORM(code) + (instancetype)code {\
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

- (NSString *)description {
    return [_name lowercaseString];
}

BUILD_TYPEFORM(SCALAR);
BUILD_TYPEFORM(ENUMERATION);
BUILD_TYPEFORM(SUBRANGE);
BUILD_TYPEFORM(ARRAY);
BUILD_TYPEFORM(RECORD);
               
@end
