//
//  Backend.h
//  Mak
//
//  Created by Alex Restrepo on 5/16/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IntermediateCode;
@protocol SymbolTable;

@interface Backend : NSObject

- (void)processWithIntermediateCode:(id<IntermediateCode>)intermediateCode table:(id<SymbolTable>)symbolTable;

@end
