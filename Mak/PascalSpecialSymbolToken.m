//
//  PascalSpecialSymbolToken.m
//  Mak
//
//  Created by Alex Restrepo on 6/8/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "PascalSpecialSymbolToken.h"

@implementation PascalSpecialSymbolToken

- (void)extract {
    unichar currentChar = [[self currentChar] characterAtIndex:0];
    
    self.text = [[NSString alloc] initWithCharacters:&currentChar length:1];
    self.type = nil;
    
    switch (currentChar) {
        case '+':
        case '-':
        case '*':
        case '/':
        case ',':
        case ';':
        case '\'':
        case '=':
        case '(':
        case ')':
        case '[':
        case ']':
        case '{':
        case '}':
        case '^':
            [self nextChar];
            break;
        
        case ':':
            currentChar = [[self nextChar] characterAtIndex:0]; //consume :
            if (currentChar == '=') {
                self.text = [self.text stringByAppendingString:[[NSString alloc] initWithCharacters:&currentChar length:1]];
                [self nextChar]; // consume =
            }
            break;
            
        case '<':
            currentChar = [[self nextChar] characterAtIndex:0]; //consume <
            if (currentChar == '=') {
                self.text = [self.text stringByAppendingString:[[NSString alloc] initWithCharacters:&currentChar length:1]];
                [self nextChar]; // consume =
                
            } else if (currentChar == '>') {
                self.text = [self.text stringByAppendingString:[[NSString alloc] initWithCharacters:&currentChar length:1]];
                [self nextChar]; // consume >
            }
            break;
            
        case '>':
            currentChar = [[self nextChar] characterAtIndex:0]; //consume >
            if (currentChar == '=') {
                self.text = [self.text stringByAppendingString:[[NSString alloc] initWithCharacters:&currentChar length:1]];
                [self nextChar]; // consume =
                
            }
            break;
        
        case '.':
            currentChar = [[self nextChar] characterAtIndex:0]; //consume .
            if (currentChar == '.') {
                self.text = [self.text stringByAppendingString:[[NSString alloc] initWithCharacters:&currentChar length:1]];
                [self nextChar]; // consume .
                
            }
            break;
            
        default:
            [self nextChar]; // consume bad char
            self.type = [PascalTokenType ERROR];
            self.value = [PascalErrorCode INVALID_CHARACTER];
            break;
    }
    
    if (!self.type) {
        self.type = [PascalTokenType tokenTypeForSpecialSymbol:self.text];
    }
    
}

@end
