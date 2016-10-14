//
//  TypeChecker.h
//  Mak
//
//  Created by Alex Restrepo on 10/12/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TypeSpec.h"

@interface TypeChecker : NSObject

+ (BOOL)isInteger:(id<TypeSpec>)type;
+ (BOOL)areBothIntegers:(id<TypeSpec>)type1 and:(id<TypeSpec>)type2;
+ (BOOL)isReal:(id<TypeSpec>)type;
+ (BOOL)isIntegerOrReal:(id<TypeSpec>)type;
+ (BOOL)isAtLeastOneReal:(id<TypeSpec>)type1 or:(id<TypeSpec>)type2;
+ (BOOL)isBoolean:(id<TypeSpec>)type;
+ (BOOL)areBothBoolean:(id<TypeSpec>)type1 and:(id<TypeSpec>)type2;
+ (BOOL)isChar:(id<TypeSpec>)type;
+ (BOOL)areAssignmentCompatibleTarget:(id<TypeSpec>)target value:(id<TypeSpec>)value;
+ (BOOL)areComparisonCompatibleType1:(id<TypeSpec>)type1 type2:(id<TypeSpec>)type2;

@end
