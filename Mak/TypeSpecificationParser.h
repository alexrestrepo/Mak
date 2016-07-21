//
//  TypeSpecificationParser.h
//  Mak
//
//  Created by Alex Restrepo on 7/24/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "PascalParserTD.h"

#import "TypeSpec.h"

@interface TypeSpecificationParser : PascalParserTD

+ (NSSet <id<TokenType>> *)typeStartSet;
- (id<TypeSpec>)parseToken:(Token *)token;

@end
