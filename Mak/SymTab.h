//
//  SymTab.h
//  Mak
//
//  Created by Alex Restrepo on 6/19/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SymbolTable.h"

@interface SymTab : NSObject <SymbolTable>

- (instancetype)initWithNestingLevel:(NSInteger)nestingLevel;

@end
