//
//  PascalWordToken.m
//  Mak
//
//  Created by Alex Restrepo on 5/29/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "PascalWordToken.h"

#import "PascalTokenType.h"

@implementation PascalWordToken

- (void)extract {
    NSMutableString *textBuffer = [NSMutableString new];
    NSString *currentChar = [self currentChar];
    
    while ([self isLetterOrDigit:currentChar]) {
        [textBuffer appendString:currentChar];
        currentChar = [self nextChar];
    }
    
    self.text = textBuffer;
    self.value = self.text;
    self.type = [PascalTokenType IDENTIFIER];
    
    if ([PascalTokenType isReservedWord:self.text]) {
        self.type = [PascalTokenType tokenTypeForReservedWord:self.text];
    }
}

- (BOOL)isLetterOrDigit:(NSString *)string {
    NSMutableCharacterSet *set = [NSMutableCharacterSet new];
    [set formUnionWithCharacterSet:[NSCharacterSet lowercaseLetterCharacterSet]];
    [set formUnionWithCharacterSet:[NSCharacterSet decimalDigitCharacterSet]];
    
    if ([[string lowercaseString] rangeOfCharacterFromSet:set].location != NSNotFound) {
        return YES;
    }
    return NO;
}

@end
