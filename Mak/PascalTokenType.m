//
//  PascalTokenType.m
//  Mak
//
//  Created by Alex Restrepo on 5/29/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "PascalTokenType.h"

typedef NS_ENUM(NSUInteger, PascalTokenTypes) {
    AND,
    ARRAY,
    BEGIN,
    CASE,
    CONST,
    DIV,
    DO,
    DOWNTO,
    ELSE,
    END,
    fILE,
    FOR,
    FUNCTION,
    GOTO,
    IF,
    IN,
    LABEL,
    MOD,
    NIL,
    NOT,
    OF,
    OR,
    PACKED,
    PROCEDURE,
    PROGRAM,
    RECORD,
    REPEAT,
    SET,
    THEN,
    TO,
    TYPE,
    UNTIL,
    VAR,
    WHILE,
    WITH,
    
    // Special symbols.
    PLUS,
    MINUS,
    STAR,
    SLASH,
    COLON_EQUALS,
    DOT,
    COMMA,
    SEMICOLON,
    COLON,
    QUOTE,
    EQUALS,
    NOT_EQUALS,
    LESS_THAN,
    LESS_EQUALS,
    GREATER_EQUALS,
    GREATER_THAN,
    LEFT_PAREN,
    RIGHT_PAREN,
    LEFT_BRACKET,
    RIGHT_BRACKET,
    LEFT_BRACE,
    RIGHT_BRACE,
    UP_ARROW,
    DOT_DOT,
    
    IDENTIFIER,
    INTEGER,
    REAL,
    STRING,
    ERROR,
    END_OF_FILE,
};

static NSMutableDictionary<NSString *, PascalTokenType*> *ReservedWords;
static NSMutableDictionary<NSString *, PascalTokenType*> *SpecialSymbols;

@interface PascalTokenType()

@property (nonatomic, assign) NSInteger ordinal;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *name;

@end

#define BUILD_TOKEN_TYPE(code, description) + (instancetype)code {\
    static PascalTokenType *thisTokenType = nil;\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        thisTokenType = [[PascalTokenType alloc] initWithName:@#code ordinal:code text:description];\
        PascalTokenTypes type = code;\
        if (type >= AND && type <= WITH) {\
            ReservedWords[[description lowercaseString]] = thisTokenType;\
        } else if (type >= PLUS && type <= DOT_DOT) {\
            SpecialSymbols[description] = thisTokenType;\
        }\
    });\
    return thisTokenType;\
}

@implementation PascalTokenType

+ (void)initialize {
    if (self == [PascalTokenType class]) {
        ReservedWords = [NSMutableDictionary new];
        SpecialSymbols = [NSMutableDictionary new];
        
        // create all ze tokens... omg
        [PascalTokenType AND];
        [PascalTokenType ARRAY];
        [PascalTokenType BEGIN];
        [PascalTokenType CASE];
        [PascalTokenType CONST];
        [PascalTokenType DIV];
        [PascalTokenType DO];
        [PascalTokenType DOWNTO];
        [PascalTokenType ELSE];
        [PascalTokenType END];
        [PascalTokenType fILE];
        [PascalTokenType FOR];
        [PascalTokenType FUNCTION];
        [PascalTokenType GOTO];
        [PascalTokenType IF];
        [PascalTokenType IN];
        [PascalTokenType LABEL];
        [PascalTokenType MOD];
        [PascalTokenType NIL];
        [PascalTokenType NOT];
        [PascalTokenType OF];
        [PascalTokenType OR];
        [PascalTokenType PACKED];
        [PascalTokenType PROCEDURE];
        [PascalTokenType PROGRAM];
        [PascalTokenType RECORD];
        [PascalTokenType REPEAT];
        [PascalTokenType SET];
        [PascalTokenType THEN];
        [PascalTokenType TO];
        [PascalTokenType TYPE];
        [PascalTokenType UNTIL];
        [PascalTokenType VAR];
        [PascalTokenType WHILE];
        [PascalTokenType WITH];
        
        [PascalTokenType PLUS];
        [PascalTokenType MINUS];
        [PascalTokenType STAR];
        [PascalTokenType SLASH];
        [PascalTokenType COLON_EQUALS];
        [PascalTokenType DOT];
        [PascalTokenType COMMA];
        [PascalTokenType SEMICOLON];
        [PascalTokenType COLON];
        [PascalTokenType QUOTE];
        [PascalTokenType EQUALS];
        [PascalTokenType NOT_EQUALS];
        [PascalTokenType LESS_THAN];
        [PascalTokenType LESS_EQUALS];
        [PascalTokenType GREATER_EQUALS];
        [PascalTokenType GREATER_THAN];
        [PascalTokenType LEFT_PAREN];
        [PascalTokenType RIGHT_PAREN];
        [PascalTokenType LEFT_BRACKET];
        [PascalTokenType RIGHT_BRACKET];
        [PascalTokenType LEFT_BRACE];
        [PascalTokenType RIGHT_BRACE];
        [PascalTokenType UP_ARROW];
        [PascalTokenType DOT_DOT];
        
        [PascalTokenType IDENTIFIER];
        [PascalTokenType INTEGER];
        [PascalTokenType REAL];
        [PascalTokenType STRING];
        
        [PascalTokenType ERROR];
        [PascalTokenType END_OF_FILE];
    }
}

- (instancetype)initWithName:(NSString *)name ordinal:(NSInteger)ordinal text:(NSString *)text {
    self = [super init];
    if (self) {
        _name = name;
        _text = [text lowercaseString];
        _ordinal = ordinal;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (NSString *)description {
    return _name;
}

+ (BOOL)isSpecialSymbol:(NSString *)symbol {
    return [self tokenTypeForSpecialSymbol:symbol] != nil;
}

+ (BOOL)isReservedWord:(NSString *)word {
    return [self tokenTypeForReservedWord:word] != nil;
}

+ (instancetype)tokenTypeForReservedWord:(NSString *)word {
    return ReservedWords[[word lowercaseString]];
}

+ (instancetype)tokenTypeForSpecialSymbol:(NSString *)symbol {
    return SpecialSymbols[symbol];
}

BUILD_TOKEN_TYPE(AND, @"AND")
BUILD_TOKEN_TYPE(ARRAY, @"ARRAY")
BUILD_TOKEN_TYPE(BEGIN, @"BEGIN")
BUILD_TOKEN_TYPE(CASE, @"CASE")
BUILD_TOKEN_TYPE(CONST, @"CONST")
BUILD_TOKEN_TYPE(DIV, @"DIV")
BUILD_TOKEN_TYPE(DO, @"DO")
BUILD_TOKEN_TYPE(DOWNTO, @"DOWNTO")
BUILD_TOKEN_TYPE(ELSE, @"ELSE")
BUILD_TOKEN_TYPE(END, @"END")
BUILD_TOKEN_TYPE(fILE, @"FILE")
BUILD_TOKEN_TYPE(FOR, @"FOR")
BUILD_TOKEN_TYPE(FUNCTION, @"FUNCTION")
BUILD_TOKEN_TYPE(GOTO, @"GOTO")
BUILD_TOKEN_TYPE(IF, @"IF")
BUILD_TOKEN_TYPE(IN, @"IN")
BUILD_TOKEN_TYPE(LABEL, @"LABEL")
BUILD_TOKEN_TYPE(MOD, @"MOD")
BUILD_TOKEN_TYPE(NIL, @"NIL")
BUILD_TOKEN_TYPE(NOT, @"NOT")
BUILD_TOKEN_TYPE(OF, @"OF")
BUILD_TOKEN_TYPE(OR, @"OR")
BUILD_TOKEN_TYPE(PACKED, @"PACKED")
BUILD_TOKEN_TYPE(PROCEDURE, @"PROCEDURE")
BUILD_TOKEN_TYPE(PROGRAM, @"PROGRAM")
BUILD_TOKEN_TYPE(RECORD, @"RECORD")
BUILD_TOKEN_TYPE(REPEAT, @"REPEAT")
BUILD_TOKEN_TYPE(SET, @"SET")
BUILD_TOKEN_TYPE(THEN, @"THEN")
BUILD_TOKEN_TYPE(TO, @"TO")
BUILD_TOKEN_TYPE(TYPE, @"TYPE")
BUILD_TOKEN_TYPE(UNTIL, @"UNTIL")
BUILD_TOKEN_TYPE(VAR, @"VAR")
BUILD_TOKEN_TYPE(WHILE, @"WHILE")
BUILD_TOKEN_TYPE(WITH, @"WITH")

BUILD_TOKEN_TYPE(PLUS, @"+")
BUILD_TOKEN_TYPE(MINUS, @"-")
BUILD_TOKEN_TYPE(STAR, @"*")
BUILD_TOKEN_TYPE(SLASH, @"/")
BUILD_TOKEN_TYPE(COLON_EQUALS, @":=")
BUILD_TOKEN_TYPE(DOT, @".")
BUILD_TOKEN_TYPE(COMMA, @",")
BUILD_TOKEN_TYPE(SEMICOLON, @";")
BUILD_TOKEN_TYPE(COLON, @":")
BUILD_TOKEN_TYPE(QUOTE, @"'")
BUILD_TOKEN_TYPE(EQUALS, @"=")
BUILD_TOKEN_TYPE(NOT_EQUALS, @"<>")
BUILD_TOKEN_TYPE(LESS_THAN, @"<")
BUILD_TOKEN_TYPE(LESS_EQUALS, @"<=")
BUILD_TOKEN_TYPE(GREATER_EQUALS, @">=")
BUILD_TOKEN_TYPE(GREATER_THAN, @">")
BUILD_TOKEN_TYPE(LEFT_PAREN, @"(")
BUILD_TOKEN_TYPE(RIGHT_PAREN, @")")
BUILD_TOKEN_TYPE(LEFT_BRACKET, @"[")
BUILD_TOKEN_TYPE(RIGHT_BRACKET, @"]")
BUILD_TOKEN_TYPE(LEFT_BRACE, @"{")
BUILD_TOKEN_TYPE(RIGHT_BRACE, @"}")
BUILD_TOKEN_TYPE(UP_ARROW, @"^")
BUILD_TOKEN_TYPE(DOT_DOT, @"..")

BUILD_TOKEN_TYPE(IDENTIFIER, @"IDENTIFIER")
BUILD_TOKEN_TYPE(INTEGER, @"INTEGER")
BUILD_TOKEN_TYPE(REAL, @"REAL")
BUILD_TOKEN_TYPE(STRING, @"STRING")

BUILD_TOKEN_TYPE(ERROR, @"ERROR")
BUILD_TOKEN_TYPE(END_OF_FILE, @"END_OF_FILE")

@end
