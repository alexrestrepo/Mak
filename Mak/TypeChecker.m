//
//  TypeChecker.m
//  Mak
//
//  Created by Alex Restrepo on 10/12/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "TypeChecker.h"
#import "Predefined.h"
#import "TypeFormImpl.h"

@implementation TypeChecker

+ (BOOL)isInteger:(id<TypeSpec>)type {
    return type && type.baseType == [Predefined integerType];
}

+ (BOOL)areBothIntegers:(id<TypeSpec>)type1 and:(id<TypeSpec>)type2 {
    return [self isInteger:type1] && [self isInteger:type2];
}

+ (BOOL)isReal:(id<TypeSpec>)type {
    return type && type.baseType == [Predefined realType];
}

+ (BOOL)isIntegerOrReal:(id<TypeSpec>)type {
    return [self isInteger:type] || [self isReal:type];
}

+ (BOOL)isAtLeastOneReal:(id<TypeSpec>)type1 or:(id<TypeSpec>)type2 {
    return (([self isReal:type1] && [self isReal:type2])
            || ([self isReal:type1] && [self isInteger:type2])
            || ([self isInteger:type1] && [self isReal:type2]));

}

+ (BOOL)isBoolean:(id<TypeSpec>)type {
    return type && type.baseType == [Predefined booleanType];
}

+ (BOOL)areBothBoolean:(id<TypeSpec>)type1 and:(id<TypeSpec>)type2 {
    return [self isBoolean:type1] && [self isBoolean:type2];
}

+ (BOOL)isChar:(id<TypeSpec>)type {
    return type && type.baseType == [Predefined charType];
}

+ (BOOL)areAssignmentCompatibleTarget:(id<TypeSpec>)target value:(id<TypeSpec>)value {
    if (!target || !value) {
        return NO;
    }

    target = target.baseType;
    value = value.baseType;

    BOOL compatible = NO;
    if (target == value) {
        compatible = YES;

    } else if ([self isReal:target] && [self isInteger:value]) {
        compatible = true;

    } else {
        compatible = [target isPascalString] && [value isPascalString];
    }

    return compatible;
}

+ (BOOL)areComparisonCompatibleType1:(id<TypeSpec>)type1 type2:(id<TypeSpec>)type2 {
    if (!type1 || !type2) {
        return NO;
    }

    type1 = type1.baseType;
    type2 = type2.baseType;
    id<TypeForm> form = [type1 form];

    BOOL compatible = NO;

    if ((type1 == type2) && ((form == [TypeFormImpl SCALAR]) || (form == [TypeFormImpl ENUMERATION]))) {
        compatible = YES;

    } else if ([self isAtLeastOneReal:type1 or:type2]) {
        compatible = YES;

    } else {
        compatible = [type1 isPascalString] && [type2 isPascalString];
    }

    return compatible;
}

@end
