//
//  PascalScanner.m
//  Mak
//
//  Created by Alex Restrepo on 5/16/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "PascalScanner.h"

#import "EofToken.h"
#import "PascalErrorToken.h"
#import "PascalTokenType.h"
#import "PascalWordToken.h"
#import "PascalStringToken.h"
#import "PascalSpecialSymbolToken.h"
#import "PascalNumberToken.h"

@implementation PascalScanner

- (Token *)extractToken {
    [self skipWhiteSpace];
    
    Token *token = nil;
    NSString *currentChar = [self currentChar];
    
    if ([currentChar isEqualToString:EndOfFile]) {
        token = [[EofToken alloc] initWithSource:self.source];
        
    } else if ([self isLetter:currentChar]) {
        token = [[PascalWordToken alloc] initWithSource:self.source];
        
    } else if ([self isDigit:currentChar]) {
        token = [[PascalNumberToken alloc] initWithSource:self.source];
        
    } else if ([currentChar isEqualToString:@"'"]) {
        token = [[PascalStringToken alloc] initWithSource:self.source];
        
    } else if ([PascalTokenType isSpecialSymbol:currentChar]) {
        token = [[PascalSpecialSymbolToken alloc] initWithSource:self.source];
        
    } else {
        token = [[PascalErrorToken alloc] initWithSource:self.source
                                               errorCode:[PascalErrorCode INVALID_CHARACTER]
                                               tokenText:currentChar];
        [self nextChar];
    }
    
    
    return token;
}

- (void)skipWhiteSpace {
    NSString *currentChar = [self currentChar];
    while ([self isWhitespace:currentChar] || [currentChar isEqualToString:@"{"]) {
        
        // comment?
        if ([currentChar isEqualToString:@"{"]) {
            do {
                currentChar = [self nextChar];
            } while (![currentChar isEqualToString:@"}"] && ![currentChar isEqualToString:EndOfFile]);
            
            if ([currentChar isEqualToString:@"}"]) { //consume }
                currentChar = [self nextChar];
            }
        }
        
        // nope
        else {
            currentChar = [self nextChar];
        }
    }
}

- (BOOL)isLetter:(NSString *)string {
    NSCharacterSet* letters = [NSCharacterSet lowercaseLetterCharacterSet];
    if ([[string lowercaseString] rangeOfCharacterFromSet:letters].location != NSNotFound) {
        return YES;
    }
    return NO;
}

- (BOOL)isDigit:(NSString *)string {
    NSCharacterSet* notDigits = [NSCharacterSet decimalDigitCharacterSet];
    if ([string rangeOfCharacterFromSet:notDigits].location != NSNotFound) {
        return YES;
    }
    return NO;
}

- (BOOL)isWhitespace:(NSString *)string {
    NSCharacterSet* whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    if ([string rangeOfCharacterFromSet:whitespace].location != NSNotFound) {
        return YES;
    }
    return NO;
}

@end
