//
//  RuntimeErrorCode.h
//  Mak
//
//  Created by Alex Restrepo on 6/30/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RuntimeErrorCode : NSObject

@property (nonatomic, assign, readonly) NSInteger ordinal;
@property (nonatomic, copy, readonly) NSString *message;

+ (instancetype)UNINITIALIZED_VALUE;
+ (instancetype)VALUE_RANGE;
+ (instancetype)INVALID_CASE_EXPRESSION_VALUE;
+ (instancetype)DIVISION_BY_ZERO;
+ (instancetype)INVALID_STANDARD_FUNCTION_ARGUMENT;
+ (instancetype)INVALID_INPUT;
+ (instancetype)STACK_OVERFLOW;
+ (instancetype)UNIMPLEMENTED_FEATURE;

@end
