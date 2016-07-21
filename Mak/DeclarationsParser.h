//
//  DeclarationsParser.h
//  Mak
//
//  Created by Alex Restrepo on 7/22/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "BlockParser.h"

@interface DeclarationsParser : BlockParser


- (void)parseToken:(Token *)token;

+ (NSSet <id<TokenType>> *)typeStartSet;
+ (NSSet <id<TokenType>> *)varStartSet;
+ (NSSet <id<TokenType>> *)routineStartSet;

@end
