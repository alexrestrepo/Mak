//
//  ExpressionParser.h
//  Mak
//
//  Created by Alex Restrepo on 6/30/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "StatementParser.h"

@interface ExpressionParser : StatementParser

+ (NSSet *)exprStartSet;

@end
