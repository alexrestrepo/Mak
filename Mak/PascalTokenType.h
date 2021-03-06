//
//  PascalTokenType.h
//  Mak
//
//  Created by Alex Restrepo on 5/29/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Token.h"

@interface PascalTokenType : NSObject <TokenType>

@property (nonatomic, assign, readonly) NSInteger ordinal;

+ (instancetype)AND;
+ (instancetype)ARRAY;
+ (instancetype)BEGIN;
+ (instancetype)CASE;
+ (instancetype)CONST;
+ (instancetype)DIV;
+ (instancetype)DO;
+ (instancetype)DOWNTO;
+ (instancetype)ELSE;
+ (instancetype)END;
+ (instancetype)fILE;
+ (instancetype)FOR;
+ (instancetype)FUNCTION;
+ (instancetype)GOTO;
+ (instancetype)IF;
+ (instancetype)IN;
+ (instancetype)LABEL;
+ (instancetype)MOD;
+ (instancetype)NIL;
+ (instancetype)NOT;
+ (instancetype)OF;
+ (instancetype)OR;
+ (instancetype)PACKED;
+ (instancetype)PROCEDURE;
+ (instancetype)PROGRAM;
+ (instancetype)RECORD;
+ (instancetype)REPEAT;
+ (instancetype)SET;
+ (instancetype)THEN;
+ (instancetype)TO;
+ (instancetype)TYPE;
+ (instancetype)UNTIL;
+ (instancetype)VAR;
+ (instancetype)WHILE;
+ (instancetype)WITH;

+ (instancetype)PLUS;
+ (instancetype)MINUS;
+ (instancetype)STAR;
+ (instancetype)SLASH;
+ (instancetype)COLON_EQUALS;
+ (instancetype)DOT;
+ (instancetype)COMMA;
+ (instancetype)SEMICOLON;
+ (instancetype)COLON;
+ (instancetype)QUOTE;
+ (instancetype)EQUALS;
+ (instancetype)NOT_EQUALS;
+ (instancetype)LESS_THAN;
+ (instancetype)LESS_EQUALS;
+ (instancetype)GREATER_EQUALS;
+ (instancetype)GREATER_THAN;
+ (instancetype)LEFT_PAREN;
+ (instancetype)RIGHT_PAREN;
+ (instancetype)LEFT_BRACKET;
+ (instancetype)RIGHT_BRACKET;
+ (instancetype)LEFT_BRACE;
+ (instancetype)RIGHT_BRACE;
+ (instancetype)UP_ARROW;
+ (instancetype)DOT_DOT;

+ (instancetype)IDENTIFIER;
+ (instancetype)INTEGER;
+ (instancetype)REAL;
+ (instancetype)STRING;
+ (instancetype)ERROR;
+ (instancetype)END_OF_FILE;

+ (BOOL)isSpecialSymbol:(NSString *)symbol;
+ (BOOL)isReservedWord:(NSString *)word;

+ (instancetype)tokenTypeForReservedWord:(NSString *)word;
+ (instancetype)tokenTypeForSpecialSymbol:(NSString *)symbol;

@end
