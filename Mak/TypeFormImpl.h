//
//  TypeFormImpl.h
//  Mak
//
//  Created by Alex Restrepo on 7/19/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TypeSpec.h"

@interface TypeFormImpl : NSObject <TypeForm>

@property (nonatomic, assign, readonly) NSInteger ordinal;
@property (nonatomic, copy, readonly) NSString *name;

+ (instancetype)SCALAR;
+ (instancetype)ENUMERATION;
+ (instancetype)SUBRANGE;
+ (instancetype)ARRAY;
+ (instancetype)RECORD;

@end
