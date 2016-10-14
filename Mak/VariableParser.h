//
//  VariableParser.h
//  Mak
//
//  Created by Alex Restrepo on 10/16/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "StatementParser.h"

@interface VariableParser : StatementParser

- (id<IntermediateCodeNode>)parseToken:(Token *)token withIdentifier:(id<SymbolTableEntry>)identifier;

@end
