//
//  PascalErrorToken.h
//  Mak
//
//  Created by Alex Restrepo on 5/29/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "PascalToken.h"

#import "PascalErrorCode.h"

@interface PascalErrorToken : PascalToken

- (instancetype)initWithSource:(Source *)source errorCode:(PascalErrorCode *)code tokenText:(NSString *)tokenText;

@end
