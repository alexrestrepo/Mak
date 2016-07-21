//
//  TypeKeyImpl.h
//  Mak
//
//  Created by Alex Restrepo on 7/19/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TypeSpec.h"

@interface TypeKeyImpl : NSObject <TypeKey>

@property (nonatomic, assign, readonly) NSInteger ordinal;
@property (nonatomic, copy, readonly) NSString *name;

+ (instancetype)ENUMERATION_CONSTANTS;
+ (instancetype)SUBRANGE_BASE_TYPE;
+ (instancetype)SUBRANGE_MIN_VALUE;
+ (instancetype)SUBRANGE_MAX_VALUE;
+ (instancetype)ARRAY_INDEX_TYPE;
+ (instancetype)ARRAY_ELEMENT_TYPE;
+ (instancetype)ARRAY_ELEMENT_COUNT;
+ (instancetype)RECORD_SYMTAB;

@end
