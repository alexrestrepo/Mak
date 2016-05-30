//
//  PascalErrorHandler.h
//  Mak
//
//  Created by Alex Restrepo on 5/29/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Token.h"
#import "PascalErrorCode.h"

@interface PascalErrorHandler : NSObject

@property (nonatomic, assign, readonly) NSInteger errorCount;

- (void)flagToken:(Token *)token withErrorCode:(PascalErrorCode *)errorCode;

@end
