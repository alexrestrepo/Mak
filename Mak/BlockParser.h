//
//  BlockParser.h
//  Mak
//
//  Created by Alex Restrepo on 7/22/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "PascalParserTD.h"

#import "IntermediateCode.h"
#import "SymbolTableEntry.h"

@interface BlockParser : PascalParserTD

- (id<IntermediateCodeNode>)parseToken:(Token *)token routineEntry:(id<SymbolTableEntry>)entry;

@end
