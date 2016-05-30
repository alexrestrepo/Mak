//
//  PascalNumberToken.m
//  Mak
//
//  Created by Alex Restrepo on 6/8/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "PascalNumberToken.h"

@implementation PascalNumberToken

- (void)extract {
    NSMutableString *buffer = [NSMutableString new];
    [self extractNumber:buffer];
    self.text = [buffer copy];
}

- (void)extractNumber:(NSMutableString *)buffer; {
    NSString *wholeDigits;
    NSString *fractionalDigits;
    NSString *exponentDigits;
    NSString *exponentSign = @"+";
    BOOL sawDot = NO;
    NSString *currentChar;
    
    self.type = [PascalTokenType INTEGER];
    wholeDigits = [self unsignedIntegerDigits:buffer];
    if (self.type == [PascalTokenType ERROR]) {
        return;
    }
    
    currentChar = [self currentChar];
    if ([currentChar isEqualToString:@"."]) {
        if ([[self peekChar] isEqualToString:@"."]) {
            sawDot = YES; // it's a .. token
            
        } else {
            self.type = [PascalTokenType REAL];
            [buffer appendString:currentChar];
            currentChar = [self nextChar];
            
            fractionalDigits = [self unsignedIntegerDigits:buffer];
            if (self.type == [PascalTokenType ERROR]) {
                return;
            }
        }
    }
    
    // exponent? can't be one if we saw ..
    currentChar = [self currentChar];
    if (!sawDot && [[currentChar lowercaseString] isEqualToString:@"e"]) {
        self.type = [PascalTokenType REAL];
        [buffer appendString:currentChar];
        currentChar = [self nextChar]; // consume E
        
        if ([currentChar isEqualToString:@"+"] || [currentChar isEqualToString:@"-"]) {
            [buffer appendString:currentChar];
            exponentSign = currentChar;
            currentChar = [self nextChar]; //consume + -
        }
        
        exponentDigits = [self unsignedIntegerDigits:buffer];
    }
    
    if (self.type == [PascalTokenType INTEGER]) {
        NSInteger integerValue = [self computeIntegerValueWithDigits:wholeDigits];
        if (self.type != [PascalTokenType ERROR]) {
            self.value = @(integerValue);
        }
        
    } else if (self.type == [PascalTokenType REAL]) {
        double floatValue = [self computeFloatValueWithWhole:wholeDigits fractional:fractionalDigits exponent:exponentDigits sign:exponentSign];
        if (self.type != [PascalTokenType ERROR]) {
            self.value = @(floatValue);
        }
    }
}

- (NSString *)unsignedIntegerDigits:(NSMutableString *)buffer {
    NSString *currentChar = [self currentChar];
    if (![self isDigit:currentChar]) {
        self.type = [PascalTokenType ERROR];
        self.value = [PascalErrorCode INVALID_NUMBER];
        return nil;
    }
    
    NSMutableString *digits = [NSMutableString new];
    while ([self isDigit:currentChar]) {
        [buffer appendString:currentChar];
        [digits appendString:currentChar];
        currentChar = [self nextChar];
    }
    return [digits copy];
}

static inline NSInteger integerValueForChar(unichar input) {
    return input - (unichar)'0';
}

- (NSInteger)computeIntegerValueWithDigits:(NSString *)digits {
    if (!digits) {
        return 0;
    }
    
    NSInteger integerValue = 0;
    NSInteger previousValue = -1; // overflow if prev > integer
    NSInteger index = 0;
    
    while ((index < [digits length]) && (integerValue >= previousValue)) {
        previousValue = integerValue;
        unichar digit = [digits characterAtIndex:index++];
        integerValue = 10 * integerValue + integerValueForChar(digit);
    }
    
    // overflow?
    if (integerValue >= previousValue) {
        return integerValue;
        
    }
    
    self.type = [PascalTokenType ERROR];
    self.value = [PascalErrorCode RANGE_INTEGER];
    return 0;
}

- (double)computeFloatValueWithWhole:(NSString *)wholeDigits fractional:(NSString *)fractionalDigits exponent:(NSString *)exponentDigits sign:(NSString *)sign {
    double floatValue = 0.0;
    NSInteger exponentValue = [self computeIntegerValueWithDigits:exponentDigits];
    NSMutableString *digits = [wholeDigits mutableCopy];
    
    if ([sign isEqualToString:@"-"]) {
        exponentValue = -exponentValue;
    }
    
    if (fractionalDigits) {
        exponentValue -= [fractionalDigits length];
        [digits appendString:fractionalDigits];
    }
    
    NSInteger maxexp = DBL_MAX_EXP;
    NSInteger testVal = ABS(exponentValue + [wholeDigits length]);
    if (testVal > maxexp) {
        self.type = [PascalTokenType ERROR];
        self.value = [PascalErrorCode RANGE_REAL];
        return 0.0;
    }
    
    NSInteger index = 0;
    while (index < [digits length]) {
        floatValue = 10 * floatValue + integerValueForChar([digits characterAtIndex:index++]);
    }
    
    if (exponentValue != 0) {
        floatValue *= pow(10, exponentValue);
    }
    
    return floatValue;
}

- (BOOL)isDigit:(NSString *)string {
    NSCharacterSet* notDigits = [NSCharacterSet decimalDigitCharacterSet];
    if ([string rangeOfCharacterFromSet:notDigits].location != NSNotFound) {
        return YES;
    }
    return NO;
}

@end
