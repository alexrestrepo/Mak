//
//  IntermediateCodeFactory.m
//  Mak
//
//  Created by Alex Restrepo on 6/29/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "IntermediateCodeFactory.h"

#import "IntermediateCodeImp.h"
#import "IntermediateCodeNodeImp.h"

@implementation IntermediateCodeFactory

+ (id<IntermediateCode>)intermediateCode {
    return [IntermediateCodeImp new];
}

+ (id<IntermediateCodeNode>)intermediateCodeNodeWithType:(id<IntermediateCodeNodeType>)type {
    return [[IntermediateCodeNodeImp alloc] initWithType:type];
}

@end
