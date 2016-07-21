//
//  Parser.h
//  Mak
//
//  Created by Alex Restrepo on 5/13/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SymbolTableFactory.h"

@class Token;
@class Scanner;
@protocol IntermediateCode;

@interface Parser : NSObject

@property (nonatomic, strong) id<IntermediateCode> intermediateCode;
@property (nonatomic, strong, readonly) Scanner *scanner;
@property (nonatomic, strong, readonly) id<SymbolTableStack> symbolTableStack;

- (instancetype)initWithScanner:(Scanner *)scanner;
- (void)parse;
- (NSInteger)errorCount;
- (Token *)currentToken;
- (Token *)nextToken;

@end
