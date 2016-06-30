//
//  IntermediateCodeKeyImp.h
//  Mak
//
//  Created by Alex Restrepo on 6/29/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IntermediateCode.h"

@interface IntermediateCodeKeyImp : NSObject <IntermediateCodeKey>

@property (nonatomic, assign, readonly) NSInteger ordinal;
@property (nonatomic, copy, readonly) NSString *name;

+ (instancetype)LINE;
+ (instancetype)ID;
+ (instancetype)VALUE;

@end
