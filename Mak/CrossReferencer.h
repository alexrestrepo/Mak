//
//  CrossReferencer.h
//  Mak
//
//  Created by Alex Restrepo on 6/19/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SymbolTableStack;

@interface CrossReferencer : NSObject

- (void)printSymbolTableStack:(id<SymbolTableStack>)symbolTableStack;

@end
