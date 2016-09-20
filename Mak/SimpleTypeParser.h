//
//  SimpleTypeParser.h
//  Mak
//
//  Created by Alex Restrepo on 7/27/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "TypeSpecificationParser.h"

@interface SimpleTypeParser : TypeSpecificationParser

+ (NSSet <id<TokenType>> *)simpleTypeStartSet;

@end
