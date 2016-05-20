//
//  Parser.m
//  Mak
//
//  Created by Alex Restrepo on 5/13/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "Parser.h"

#import "Macros.h"
#import "SymbolTable.h"
#import "Scanner.h"
#import "IntermediateCode.h"
#import "Token.h"

static id<SymbolTable> SymbolTable;

@interface Parser()

@property (nonatomic, strong) Scanner *scanner;
@property (nonatomic, strong) id<IntermediateCode> intermediateCode;

@end

@implementation Parser

- (instancetype)initWithScanner:(Scanner *)scanner {
    self = [super init];
    if (self) {
        _scanner = scanner;
    }
    return self;
}

- (void)parse AR_ABSTRACT_METHOD;
- (NSInteger)errorCount AR_ABSTRACT_METHOD;

- (Token *)currentToken {
    return [_scanner currentToken];
}

- (Token *)nextToken {
    return [_scanner nextToken];
}

- (id<SymbolTable>)symbolTable {
    return SymbolTable;
}

@end
