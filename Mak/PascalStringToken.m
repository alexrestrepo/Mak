//
//  PascalStringToken.m
//  Mak
//
//  Created by Alex Restrepo on 5/29/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "PascalStringToken.h"

#import "PascalErrorCode.h"

@implementation PascalStringToken

- (void)extract {
    NSMutableString *textBuffer = [NSMutableString new];
    NSMutableString *valueBuffer = [NSMutableString new];
    
    NSString *currentChar = [self nextChar]; // consume initial '
    [textBuffer appendString:@"'"];
    
    do {
        if ([self isWhitespace:currentChar]) {
            currentChar = @" ";
        }
        
        if (![currentChar isEqualToString:@"'"] && ![currentChar isEqualToString:EndOfFile]) {
            [textBuffer appendString:currentChar];
            [valueBuffer appendString:currentChar];
            currentChar = [self nextChar];
        }
        
        if ([currentChar isEqualToString:@"'"]) {
            while ([currentChar isEqualToString:@"'" ] && [[self peekChar] isEqualToString:@"'"]) { // '' = '
                [textBuffer appendString:@"''"];
                [valueBuffer appendString:currentChar]; // append single '
                currentChar = [self nextChar]; //consume '
                currentChar = [self nextChar];
            }
        }
        
    } while (![currentChar isEqualToString:@"'"] && ![currentChar isEqualToString:EndOfFile]);
    
    if ([currentChar isEqualToString:@"'"]) {
        [self nextChar];
        
        [textBuffer appendString:@"'"];
        self.type = [PascalTokenType STRING];
        self.value = valueBuffer;
        
    } else {
        self.type = [PascalTokenType ERROR];
        self.value = [PascalErrorCode UNEXPECTED_EOF];
    }
    
    self.text = textBuffer;
}


- (BOOL)isWhitespace:(NSString *)string {
    NSCharacterSet* whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    if ([string rangeOfCharacterFromSet:whitespace].location != NSNotFound) {
        return YES;
    }
    return NO;
}

@end
