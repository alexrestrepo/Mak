//
//  NSNumber+Type.m
//  Mak
//
//  Created by Alex Restrepo on 7/1/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "NSNumber+Type.h"

@implementation NSNumber (Type)

- (BOOL)arg_isFloat {
    CFNumberType numberType = CFNumberGetType((CFNumberRef)self);
    if (numberType == kCFNumberFloatType
        || numberType == kCFNumberDoubleType
        || numberType == kCFNumberCGFloatType
        || numberType == kCFNumberFloat32Type
        || numberType == kCFNumberFloat64Type) {
        
        return YES;
    }
    
    return NO;
}

- (BOOL)arg_isInteger {
    return ![self arg_isFloat];
}

@end
