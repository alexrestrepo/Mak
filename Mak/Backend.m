//
//  Backend.m
//  Mak
//
//  Created by Alex Restrepo on 5/16/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "Backend.h"

#import "SymbolTableStack.h"
#import "IntermediateCode.h"
#import "Macros.h"


@interface Backend ()

@property (nonatomic, strong) id<SymbolTableStack> symbolTableStack;
@property (nonatomic, strong) id<IntermediateCode> intermediateCode;

@end

@implementation Backend

- (void)processWithIntermediateCode:(id<IntermediateCode>)intermediateCode table:(id<SymbolTableStack>)symbolTableStack AR_ABSTRACT_METHOD;

@end
