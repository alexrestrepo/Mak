//
//  IntermediateCodeNodeTypeImp.m
//  Mak
//
//  Created by Alex Restrepo on 6/29/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "IntermediateCodeNodeTypeImp.h"

typedef NS_ENUM(NSUInteger, IntermediateCodeNodeTypes) {
    // Program structure
    PROGRAM, PROCEDURE, FUNCTION,
    
    // Statements
    COMPOUND, ASSIGN, LOOP, TEST, CALL, PARAMETERS,
    IF, SELECT, SELECT_BRANCH, SELECT_CONSTANTS, NO_OP,
    
    // Relational operators
    EQ, NE, LT, LE, GT, GE, NOT,
    
    // Additive operators
    ADD, SUBTRACT, OR, NEGATE,
    
    // Multiplicative operators
    MULTIPLY, INTEGER_DIVIDE, FLOAT_DIVIDE, MOD, AND,
    
    // Operands
    VARIABLE, SUBSCRIPTS, FIELD,
    INTEGER_CONSTANT, REAL_CONSTANT,
    STRING_CONSTANT, BOOLEAN_CONSTANT,
    
    // WRITE parameter
    WRITE_PARM,
};

@implementation IntermediateCodeNodeTypeImp

#define BUILD_ICODETYPE(code) + (instancetype)code {\
    static IntermediateCodeNodeTypeImp *thisType = nil;\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        thisType = [[IntermediateCodeNodeTypeImp alloc] initWithOrdinal:code name:@#code];\
    });\
    return thisType;\
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
    return _name;
}

BUILD_ICODETYPE(PROGRAM);
BUILD_ICODETYPE(PROCEDURE);
BUILD_ICODETYPE(FUNCTION);
BUILD_ICODETYPE(COMPOUND);
BUILD_ICODETYPE(ASSIGN);
BUILD_ICODETYPE(LOOP);
BUILD_ICODETYPE(TEST);
BUILD_ICODETYPE(CALL);
BUILD_ICODETYPE(PARAMETERS);
BUILD_ICODETYPE(IF);
BUILD_ICODETYPE(SELECT);
BUILD_ICODETYPE(SELECT_BRANCH);
BUILD_ICODETYPE(SELECT_CONSTANTS);
BUILD_ICODETYPE(NO_OP);
BUILD_ICODETYPE(EQ);
BUILD_ICODETYPE(NE);
BUILD_ICODETYPE(LT);
BUILD_ICODETYPE(LE);
BUILD_ICODETYPE(GT);
BUILD_ICODETYPE(GE);
BUILD_ICODETYPE(NOT);
BUILD_ICODETYPE(ADD);
BUILD_ICODETYPE(SUBTRACT);
BUILD_ICODETYPE(OR);
BUILD_ICODETYPE(NEGATE);
BUILD_ICODETYPE(MULTIPLY);
BUILD_ICODETYPE(INTEGER_DIVIDE);
BUILD_ICODETYPE(FLOAT_DIVIDE);
BUILD_ICODETYPE(MOD);
BUILD_ICODETYPE(AND);
BUILD_ICODETYPE(VARIABLE);
BUILD_ICODETYPE(SUBSCRIPTS);
BUILD_ICODETYPE(FIELD);
BUILD_ICODETYPE(INTEGER_CONSTANT);
BUILD_ICODETYPE(REAL_CONSTANT);
BUILD_ICODETYPE(STRING_CONSTANT);
BUILD_ICODETYPE(BOOLEAN_CONSTANT);
BUILD_ICODETYPE(WRITE_PARM);

@end
