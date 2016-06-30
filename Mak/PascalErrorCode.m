//
//  PascalErrorCode.m
//  Mak
//
//  Created by Alex Restrepo on 5/29/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "PascalErrorCode.h"

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


@interface PascalErrorCode()

@property (nonatomic, assign) NSInteger ordinal;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *message;

@end

#define BUILD_FULL_ERROR_CODE(code, description, statusCode) + (instancetype)code {\
    static PascalErrorCode *thisErrorCode = nil;\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        thisErrorCode = [[PascalErrorCode alloc] initWithMessage:description status:statusCode ordinal:code];\
    });\
    return thisErrorCode;\
}

#define BUILD_ERROR_CODE(code, description) BUILD_FULL_ERROR_CODE(code, description, 0)

@implementation PascalErrorCode

+ (void)initialize {
    if (self == [PascalErrorCode class]) {
        [PascalErrorCode ALREADY_FORWARDED];
        [PascalErrorCode CASE_CONSTANT_REUSED];
        [PascalErrorCode IDENTIFIER_REDEFINED];
        [PascalErrorCode IDENTIFIER_UNDEFINED];
        [PascalErrorCode INCOMPATIBLE_ASSIGNMENT];
        [PascalErrorCode INCOMPATIBLE_TYPES];
        [PascalErrorCode INVALID_ASSIGNMENT];
        [PascalErrorCode INVALID_CHARACTER];
        [PascalErrorCode INVALID_CONSTANT];
        [PascalErrorCode INVALID_EXPONENT];
        [PascalErrorCode INVALID_EXPRESSION];
        [PascalErrorCode INVALID_FIELD];
        [PascalErrorCode INVALID_FRACTION];
        [PascalErrorCode INVALID_IDENTIFIER_USAGE];
        [PascalErrorCode INVALID_INDEX_TYPE];
        [PascalErrorCode INVALID_NUMBER];
        [PascalErrorCode INVALID_STATEMENT];
        [PascalErrorCode INVALID_SUBRANGE_TYPE];
        [PascalErrorCode INVALID_TARGET];
        [PascalErrorCode INVALID_TYPE];
        [PascalErrorCode INVALID_VAR_PARM];
        [PascalErrorCode MIN_GT_MAX];
        [PascalErrorCode MISSING_BEGIN];
        [PascalErrorCode MISSING_COLON];
        [PascalErrorCode MISSING_COLON_EQUALS];
        [PascalErrorCode MISSING_COMMA];
        [PascalErrorCode MISSING_CONSTANT];
        [PascalErrorCode MISSING_DO];
        [PascalErrorCode MISSING_DOT_DOT];
        [PascalErrorCode MISSING_END];
        [PascalErrorCode MISSING_EQUALS];
        [PascalErrorCode MISSING_FOR_CONTROL];
        [PascalErrorCode MISSING_IDENTIFIER];
        [PascalErrorCode MISSING_LEFT_BRACKET];
        [PascalErrorCode MISSING_OF];
        [PascalErrorCode MISSING_PERIOD];
        [PascalErrorCode MISSING_PROGRAM];
        [PascalErrorCode MISSING_RIGHT_BRACKET];
        [PascalErrorCode MISSING_RIGHT_PAREN];
        [PascalErrorCode MISSING_SEMICOLON];
        [PascalErrorCode MISSING_THEN];
        [PascalErrorCode MISSING_TO_DOWNTO];
        [PascalErrorCode MISSING_UNTIL];
        [PascalErrorCode MISSING_VARIABLE];
        [PascalErrorCode NOT_CONSTANT_IDENTIFIER];
        [PascalErrorCode NOT_RECORD_VARIABLE];
        [PascalErrorCode NOT_TYPE_IDENTIFIER];
        [PascalErrorCode RANGE_INTEGER];
        [PascalErrorCode RANGE_REAL];
        [PascalErrorCode STACK_OVERFLOW];
        [PascalErrorCode TOO_MANY_LEVELS];
        [PascalErrorCode TOO_MANY_SUBSCRIPTS];
        [PascalErrorCode UNEXPECTED_EOF];
        [PascalErrorCode UNEXPECTED_TOKEN];
        [PascalErrorCode UNIMPLEMENTED];
        [PascalErrorCode UNRECOGNIZABLE];
        [PascalErrorCode WRONG_NUMBER_OF_PARMS];
        [PascalErrorCode IO_ERROR];
        [PascalErrorCode TOO_MANY_ERRORS];
    }
}

- (instancetype)initWithMessage:(NSString *)message status:(NSInteger)status ordinal:(NSInteger)ordinal {
    self = [super init];
    if (self) {
        _message = message;
        _status = status;
        _ordinal = ordinal;
    }
    return self;
}

- (NSString *)description {
    return _message;
}

BUILD_ERROR_CODE(ALREADY_FORWARDED, @"Already specified in FORWARD")
BUILD_ERROR_CODE(CASE_CONSTANT_REUSED, @"CASE constant reused")
BUILD_ERROR_CODE(IDENTIFIER_REDEFINED, @"Redefined identifier")
BUILD_ERROR_CODE(IDENTIFIER_UNDEFINED, @"Undefined identifier")
BUILD_ERROR_CODE(INCOMPATIBLE_ASSIGNMENT, @"Incompatible assignment")
BUILD_ERROR_CODE(INCOMPATIBLE_TYPES, @"Incompatible types")
BUILD_ERROR_CODE(INVALID_ASSIGNMENT, @"Invalid assignment statement")
BUILD_ERROR_CODE(INVALID_CHARACTER, @"Invalid character")
BUILD_ERROR_CODE(INVALID_CONSTANT, @"Invalid constant")
BUILD_ERROR_CODE(INVALID_EXPONENT, @"Invalid exponent")
BUILD_ERROR_CODE(INVALID_EXPRESSION, @"Invalid expression")
BUILD_ERROR_CODE(INVALID_FIELD, @"Invalid field")
BUILD_ERROR_CODE(INVALID_FRACTION, @"Invalid fraction")
BUILD_ERROR_CODE(INVALID_IDENTIFIER_USAGE, @"Invalid identifier usage")
BUILD_ERROR_CODE(INVALID_INDEX_TYPE, @"Invalid index type")
BUILD_ERROR_CODE(INVALID_NUMBER, @"Invalid number")
BUILD_ERROR_CODE(INVALID_STATEMENT, @"Invalid statement")
BUILD_ERROR_CODE(INVALID_SUBRANGE_TYPE, @"Invalid subrange type")
BUILD_ERROR_CODE(INVALID_TARGET, @"Invalid assignment target")
BUILD_ERROR_CODE(INVALID_TYPE, @"Invalid type")
BUILD_ERROR_CODE(INVALID_VAR_PARM, @"Invalid VAR parameter")
BUILD_ERROR_CODE(MIN_GT_MAX, @"Min limit greater than max limit")
BUILD_ERROR_CODE(MISSING_BEGIN, @"Missing BEGIN")
BUILD_ERROR_CODE(MISSING_COLON, @"Missing :")
BUILD_ERROR_CODE(MISSING_COLON_EQUALS, @"Missing :=")
BUILD_ERROR_CODE(MISSING_COMMA, @"Missing ,")
BUILD_ERROR_CODE(MISSING_CONSTANT, @"Missing constant")
BUILD_ERROR_CODE(MISSING_DO, @"Missing DO")
BUILD_ERROR_CODE(MISSING_DOT_DOT, @"Missing ..")
BUILD_ERROR_CODE(MISSING_END, @"Missing END")
BUILD_ERROR_CODE(MISSING_EQUALS, @"Missing =")
BUILD_ERROR_CODE(MISSING_FOR_CONTROL, @"Invalid FOR control variable")
BUILD_ERROR_CODE(MISSING_IDENTIFIER, @"Missing identifier")
BUILD_ERROR_CODE(MISSING_LEFT_BRACKET, @"Missing [")
BUILD_ERROR_CODE(MISSING_OF, @"Missing OF")
BUILD_ERROR_CODE(MISSING_PERIOD, @"Missing .")
BUILD_ERROR_CODE(MISSING_PROGRAM, @"Missing PROGRAM")
BUILD_ERROR_CODE(MISSING_RIGHT_BRACKET, @"Missing ]")
BUILD_ERROR_CODE(MISSING_RIGHT_PAREN, @"Missing )")
BUILD_ERROR_CODE(MISSING_SEMICOLON, @"Missing ;")
BUILD_ERROR_CODE(MISSING_THEN, @"Missing THEN")
BUILD_ERROR_CODE(MISSING_TO_DOWNTO, @"Missing TO or DOWNTO")
BUILD_ERROR_CODE(MISSING_UNTIL, @"Missing UNTIL")
BUILD_ERROR_CODE(MISSING_VARIABLE, @"Missing variable")
BUILD_ERROR_CODE(NOT_CONSTANT_IDENTIFIER, @"Not a constant identifier")
BUILD_ERROR_CODE(NOT_RECORD_VARIABLE, @"Not a record variable")
BUILD_ERROR_CODE(NOT_TYPE_IDENTIFIER, @"Not a type identifier")
BUILD_ERROR_CODE(RANGE_INTEGER, @"Integer literal out of range")
BUILD_ERROR_CODE(RANGE_REAL, @"Real literal out of range")
BUILD_ERROR_CODE(STACK_OVERFLOW, @"Stack overflow")
BUILD_ERROR_CODE(TOO_MANY_LEVELS, @"Nesting level too deep")
BUILD_ERROR_CODE(TOO_MANY_SUBSCRIPTS, @"Too many subscripts")
BUILD_ERROR_CODE(UNEXPECTED_EOF, @"Unexpected end of file")
BUILD_ERROR_CODE(UNEXPECTED_TOKEN, @"Unexpected token")
BUILD_ERROR_CODE(UNIMPLEMENTED, @"Unimplemented feature")
BUILD_ERROR_CODE(UNRECOGNIZABLE, @"Unrecognizable input")
BUILD_ERROR_CODE(WRONG_NUMBER_OF_PARMS, @"Wrong number of actual parameters")
BUILD_FULL_ERROR_CODE(IO_ERROR, @"Object I/O error", -101)
BUILD_FULL_ERROR_CODE(TOO_MANY_ERRORS, @"Too many syntax errors", -102)

@end
