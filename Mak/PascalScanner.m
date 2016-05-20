//
//  PascalScanner.m
//  Mak
//
//  Created by Alex Restrepo on 5/16/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "PascalScanner.h"

#import "EofToken.h"

@implementation PascalScanner

- (Token *)extractToken {
    Token *token = nil;
    NSString *currentChar = [self currentChar];
    
    if ([currentChar isEqualToString:EndOfFile]) {
        token = [[EofToken alloc] initWithSource:self.source];
        
    } else {
        token = [[Token alloc] initWithSource:self.source];
    }
    
    return token;
}

@end
