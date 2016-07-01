//
//  RuntimeErrorCode.m
//  Mak
//
//  Created by Alex Restrepo on 6/30/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "RuntimeErrorCode.h"

typedef NS_ENUM(NSUInteger, RuntimeErrorCodes) {
    UNINITIALIZED_VALUE,
    VALUE_RANGE,
    INVALID_CASE_EXPRESSION_VALUE,
    DIVISION_BY_ZERO,
    INVALID_STANDARD_FUNCTION_ARGUMENT,
    INVALID_INPUT,
    STACK_OVERFLOW,
    UNIMPLEMENTED_FEATURE,
};

@implementation RuntimeErrorCode

#define BUILD_RUNTIME_ERROR_CODE(code, description) + (instancetype)code {\
    static id this = nil;\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        this = [[self alloc] initWithMessage:description ordinal:code];\
    });\
    return this;\
}

- (instancetype)initWithMessage:(NSString *)message ordinal:(NSInteger)ordinal {
    self = [super init];
    if (self) {
        _ordinal = ordinal;
        _message = message;
    }
    return self;
}

- (NSString *)description {
    return _message;
}

BUILD_RUNTIME_ERROR_CODE(UNINITIALIZED_VALUE, @"Uninitialized value");
BUILD_RUNTIME_ERROR_CODE(VALUE_RANGE, @"Value out of range");
BUILD_RUNTIME_ERROR_CODE(INVALID_CASE_EXPRESSION_VALUE, @"Invalid CASE expression value");
BUILD_RUNTIME_ERROR_CODE(DIVISION_BY_ZERO, @"Division by zero");
BUILD_RUNTIME_ERROR_CODE(INVALID_STANDARD_FUNCTION_ARGUMENT, @"Invalid standard function argument");
BUILD_RUNTIME_ERROR_CODE(INVALID_INPUT, @"Invalid input");
BUILD_RUNTIME_ERROR_CODE(STACK_OVERFLOW, @"Runtime stack overflow");
BUILD_RUNTIME_ERROR_CODE(UNIMPLEMENTED_FEATURE, @"Unimplemented runtime feature");

@end
