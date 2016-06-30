//
//  IntermediateCodeFactory.h
//  Mak
//
//  Created by Alex Restrepo on 6/29/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IntermediateCode.h"

@interface IntermediateCodeFactory : NSObject

+ (id<IntermediateCode>)intermediateCode;
+ (id<IntermediateCodeNode>)intermediateCodeNodeWithType:(id<IntermediateCodeNodeType>)type;

@end
