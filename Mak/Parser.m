//
//  Parser.m
//  Mak
//
//  Created by Alex Restrepo on 5/13/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "Parser.h"

#import "Macros.h"
#import "SymbolTableFactory.h"
#import "Scanner.h"
#import "IntermediateCode.h"
#import "Token.h"

static id<SymbolTableStack> SymbolTableStack;

@implementation Parser

+ (void)initialize {
    if (self == [Parser class]) {
        SymbolTableStack = [SymbolTableFactory symbolTableStack];
    }
}

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

- (id<SymbolTableStack>)symbolTableStack {
    return SymbolTableStack;
}

@end
