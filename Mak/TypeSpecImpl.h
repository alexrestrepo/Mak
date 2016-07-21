//
//  TypeSpecImpl.h
//  Mak
//
//  Created by Alex Restrepo on 7/19/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TypeSpec.h"

@interface TypeSpecImpl : NSObject <TypeSpec>

- (instancetype)initWithForm:(id<TypeForm>)form;
- (instancetype)initWithString:(NSString *)value;

@end
