//
//  TypeFactory.h
//  Mak
//
//  Created by Alex Restrepo on 7/20/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TypeSpec.h"

@interface TypeFactory : NSObject

+ (id<TypeSpec>)typeWithForm:(id<TypeForm>)form;
+ (id<TypeSpec>)typeWithString:(NSString *)string;

@end
