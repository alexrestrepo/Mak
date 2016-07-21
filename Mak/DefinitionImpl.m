//
//  DefinitionImpl.m
//  Mak
//
//  Created by Alex Restrepo on 7/22/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "DefinitionImpl.h"

typedef NS_ENUM(NSUInteger, Definitions) {
    CONSTANT,
    ENUMERATION_CONSTANT,
    TYPE, VARIABLE,
    FIELD,
    VALUE_PARM,
    VAR_PARM,
    PROGRAM_PARM,
    PROGRAM,
    PROCEDURE, FUNCTION,
    UNDEFINED
};

@interface DefinitionImpl()

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger ordinal;

@end

@implementation DefinitionImpl

#define BUILD_FULL_DEF(code, description) + (instancetype)code {\
    static id this = nil;\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        this = [[self alloc] initWithMessage:description name:@#code ordinal:code];\
    });\
    return this;\
}

#define BUILD_DEF(name) BUILD_FULL_DEF(name, @#name)

- (instancetype)initWithMessage:(NSString *)message name:(NSString *)name ordinal:(NSInteger)ordinal {
    self = [super init];
    if (self) {
        _text = [message lowercaseString];
        _name = name;
        _ordinal = ordinal;
    }
    return self;
}

- (NSString *)description {
    return _name;
}

BUILD_DEF(CONSTANT);
BUILD_FULL_DEF(ENUMERATION_CONSTANT, @"enumeration constant");
BUILD_DEF(TYPE);
BUILD_DEF(VARIABLE);
BUILD_FULL_DEF(FIELD, @"record field");
BUILD_FULL_DEF(VALUE_PARM, @"value parameter");
BUILD_FULL_DEF(VAR_PARM, @"VAR parameter");
BUILD_FULL_DEF(PROGRAM_PARM, @"program parameter");
BUILD_DEF(PROGRAM);
BUILD_DEF(PROCEDURE);
BUILD_DEF(FUNCTION);
BUILD_DEF(UNDEFINED);

@end
