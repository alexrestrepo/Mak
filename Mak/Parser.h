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
@protocol SymbolTable;

@interface Parser : NSObject

@property (nonatomic, strong, readonly) id<IntermediateCode> intermediateCode;
@property (nonatomic, strong, readonly) id<SymbolTable> symbolTable;

- (instancetype)initWithScanner:(Scanner *)scanner;
- (void)parse;
- (NSInteger)errorCount;
- (Token *)currentToken;
- (Token *)nextToken;

@end
