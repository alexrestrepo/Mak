//
//  ConstantDefinitionsParser.h
//  Mak
//
//  Created by Alex Restrepo on 7/24/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "DeclarationsParser.h"

@interface ConstantDefinitionsParser : DeclarationsParser

+(NSSet <id<TokenType>> *)constantStartSet;
- (id)parseConstantWithToken:(Token *)token;
- (id<TypeSpec>)constantTypeForValue:(id)value;
- (id<TypeSpec>)constantTypeForToken:(Token *)token;

@end
