//
//  PascalErrorCode.h
//  Mak
//
//  Created by Alex Restrepo on 5/29/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import <Foundation/Foundation.h>

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
