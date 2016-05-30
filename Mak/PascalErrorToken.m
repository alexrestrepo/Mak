//
//  PascalErrorToken.m
//  Mak
//
//  Created by Alex Restrepo on 5/29/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "PascalErrorToken.h"

@implementation PascalErrorToken

- (instancetype)initWithSource:(Source *)source errorCode:(PascalErrorCode *)code tokenText:(NSString *)tokenText {
    self = [super initWithSource:source];
    if (self) {
        self.text = tokenText;
        self.type = [PascalTokenType ERROR];
        self.value = code;
    }
    return self;
}

- (void)extract {
    
}

@end
