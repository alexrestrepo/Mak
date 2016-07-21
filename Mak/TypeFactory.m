//
//  TypeFactory.m
//  Mak
//
//  Created by Alex Restrepo on 7/20/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "TypeFactory.h"

#import "TypeSpecImpl.h"

@implementation TypeFactory

+ (id<TypeSpec>)typeWithForm:(id<TypeForm>)form {
    return [[TypeSpecImpl alloc] initWithForm:form];
}

+ (id<TypeSpec>)typeWithString:(NSString *)string {
    return [[TypeSpecImpl alloc] initWithString:string];
}

@end
