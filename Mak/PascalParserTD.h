//
//  PascalParserTD.h
//  Mak
//
//  Created by Alex Restrepo on 5/16/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "Parser.h"

#import "PascalErrorHandler.h"

@interface PascalParserTD : Parser

@property (nonatomic, strong, readonly) PascalErrorHandler *errorHandler;
- (instancetype)initWithParent:(PascalParserTD *)parent;

@end
