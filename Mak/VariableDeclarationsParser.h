//
//  VariableDeclarationsParser.h
//  Mak
//
//  Created by Alex Restrepo on 7/24/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "DeclarationsParser.h"

#import "Definition.h"

@interface VariableDeclarationsParser : DeclarationsParser

@property (nonatomic, strong) id<Definition> definition;

@end
