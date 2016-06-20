//
//  SymTabStack.h
//  Mak
//
//  Created by Alex Restrepo on 6/19/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "SymbolTableStack.h"

@interface SymTabStack : NSObject <SymbolTableStack>

@property (nonatomic, assign, readonly) NSInteger currentNestingLevel;

@end
