//
//  Parser.h
//  Mak
//
//  Created by Alex Restrepo on 5/13/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Token;
@class Scanner;
@protocol IntermediateCode;
@protocol SymbolTableStack;

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
