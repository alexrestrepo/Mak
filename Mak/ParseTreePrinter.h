//
//  ParseTreePrinter.h
//  Mak
//
//  Created by Alex Restrepo on 6/29/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IntermediateCode.h"
#import "SymbolTableStack.h"

@interface ParseTreePrinter : NSObject

- (NSString *)stringFromIntermediateCode:(id<IntermediateCode>)code;
- (NSString *)stringFromSymbolTableStack:(id<SymbolTableStack>)stack;

@end
