//
//  PascalErrorCode.h
//  Mak
//
//  Created by Alex Restrepo on 5/29/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PascalErrorCodes) {
    ALREADY_FORWARDED,
    CASE_CONSTANT_REUSED,
    IDENTIFIER_REDEFINED,
    IDENTIFIER_UNDEFINED,
    INCOMPATIBLE_ASSIGNMENT,
    INCOMPATIBLE_TYPES,
    INVALID_ASSIGNMENT,
    INVALID_CHARACTER,
    INVALID_CONSTANT,
    INVALID_EXPONENT,
    INVALID_EXPRESSION,
    INVALID_FIELD,
    INVALID_FRACTION,
    INVALID_IDENTIFIER_USAGE,
    INVALID_INDEX_TYPE,
    INVALID_NUMBER,
    INVALID_STATEMENT,
    INVALID_SUBRANGE_TYPE,
    INVALID_TARGET,
    INVALID_TYPE,
    INVALID_VAR_PARM,
    MIN_GT_MAX,
    MISSING_BEGIN,
    MISSING_COLON,
    MISSING_COLON_EQUALS,
    MISSING_COMMA,
    MISSING_CONSTANT,
    MISSING_DO,
    MISSING_DOT_DOT,
    MISSING_END,
    MISSING_EQUALS,
    MISSING_FOR_CONTROL,
    MISSING_IDENTIFIER,
    MISSING_LEFT_BRACKET,
    MISSING_OF,
    MISSING_PERIOD,
    MISSING_PROGRAM,
    MISSING_RIGHT_BRACKET,
    MISSING_RIGHT_PAREN,
    MISSING_SEMICOLON,
    MISSING_THEN,
    MISSING_TO_DOWNTO,
    MISSING_UNTIL,
    MISSING_VARIABLE,
    NOT_CONSTANT_IDENTIFIER,
    NOT_RECORD_VARIABLE,
    NOT_TYPE_IDENTIFIER,
    RANGE_INTEGER,
    RANGE_REAL,
    STACK_OVERFLOW,
    TOO_MANY_LEVELS,
    TOO_MANY_SUBSCRIPTS,
    UNEXPECTED_EOF,
    UNEXPECTED_TOKEN,
    UNIMPLEMENTED,
    UNRECOGNIZABLE,
    WRONG_NUMBER_OF_PARMS,
    
    // Fatal errors.
    IO_ERROR,
    TOO_MANY_ERRORS,
};

@interface PascalErrorCode : NSObject

@property (nonatomic, assign, readonly) NSInteger ordinal;
@property (nonatomic, assign, readonly) NSInteger status;
@property (nonatomic, copy, readonly) NSString *message;

+ (instancetype)ALREADY_FORWARDED;
+ (instancetype)CASE_CONSTANT_REUSED;
+ (instancetype)IDENTIFIER_REDEFINED;
+ (instancetype)IDENTIFIER_UNDEFINED;
+ (instancetype)INCOMPATIBLE_ASSIGNMENT;
+ (instancetype)INCOMPATIBLE_TYPES;
+ (instancetype)INVALID_ASSIGNMENT;
+ (instancetype)INVALID_CHARACTER;
+ (instancetype)INVALID_CONSTANT;
+ (instancetype)INVALID_EXPONENT;
+ (instancetype)INVALID_EXPRESSION;
+ (instancetype)INVALID_FIELD;
+ (instancetype)INVALID_FRACTION;
+ (instancetype)INVALID_IDENTIFIER_USAGE;
+ (instancetype)INVALID_INDEX_TYPE;
+ (instancetype)INVALID_NUMBER;
+ (instancetype)INVALID_STATEMENT;
+ (instancetype)INVALID_SUBRANGE_TYPE;
+ (instancetype)INVALID_TARGET;
+ (instancetype)INVALID_TYPE;
+ (instancetype)INVALID_VAR_PARM;
+ (instancetype)MIN_GT_MAX;
+ (instancetype)MISSING_BEGIN;
+ (instancetype)MISSING_COLON;
+ (instancetype)MISSING_COLON_EQUALS;
+ (instancetype)MISSING_COMMA;
+ (instancetype)MISSING_CONSTANT;
+ (instancetype)MISSING_DO;
+ (instancetype)MISSING_DOT_DOT;
+ (instancetype)MISSING_END;
+ (instancetype)MISSING_EQUALS;
+ (instancetype)MISSING_FOR_CONTROL;
+ (instancetype)MISSING_IDENTIFIER;
+ (instancetype)MISSING_LEFT_BRACKET;
+ (instancetype)MISSING_OF;
+ (instancetype)MISSING_PERIOD;
+ (instancetype)MISSING_PROGRAM;
+ (instancetype)MISSING_RIGHT_BRACKET;
+ (instancetype)MISSING_RIGHT_PAREN;
+ (instancetype)MISSING_SEMICOLON;
+ (instancetype)MISSING_THEN;
+ (instancetype)MISSING_TO_DOWNTO;
+ (instancetype)MISSING_UNTIL;
+ (instancetype)MISSING_VARIABLE;
+ (instancetype)NOT_CONSTANT_IDENTIFIER;
+ (instancetype)NOT_RECORD_VARIABLE;
+ (instancetype)NOT_TYPE_IDENTIFIER;
+ (instancetype)RANGE_INTEGER;
+ (instancetype)RANGE_REAL;
+ (instancetype)STACK_OVERFLOW;
+ (instancetype)TOO_MANY_LEVELS;
+ (instancetype)TOO_MANY_SUBSCRIPTS;
+ (instancetype)UNEXPECTED_EOF;
+ (instancetype)UNEXPECTED_TOKEN;
+ (instancetype)UNIMPLEMENTED;
+ (instancetype)UNRECOGNIZABLE;
+ (instancetype)WRONG_NUMBER_OF_PARMS;
+ (instancetype)IO_ERROR;
+ (instancetype)TOO_MANY_ERRORS;

@end
