//
//  Backend.h
//  Mak
//
//  Created by Alex Restrepo on 5/16/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SymbolTableStack.h"
#import "IntermediateCode.h"

@interface Backend : NSObject

@property (nonatomic, strong) id<SymbolTableStack> symbolTableStack;
@property (nonatomic, strong) id<IntermediateCode> intermediateCode;

- (void)processWithIntermediateCode:(id<IntermediateCode>)intermediateCode table:(id<SymbolTableStack>)symbolTableStack;

@end
