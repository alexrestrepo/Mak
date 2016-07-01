//
//  RuntimeErrorHandler.h
//  Mak
//
//  Created by Alex Restrepo on 6/30/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RuntimeErrorCode.h"
#import "IntermediateCode.h"

@interface RuntimeErrorHandler : NSObject

@property (nonatomic, assign, readonly) NSInteger errorCount;
- (void)flagNode:(id<IntermediateCodeNode>)node withErrorCode:(RuntimeErrorCode *)errorCode;

@end
