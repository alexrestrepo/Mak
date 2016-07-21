//
//  DefinitionImpl.h
//  Mak
//
//  Created by Alex Restrepo on 7/22/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Definition.h"

@interface DefinitionImpl : NSObject <Definition>

+ (instancetype)CONSTANT;
+ (instancetype)ENUMERATION_CONSTANT;
+ (instancetype)TYPE;
+ (instancetype)VARIABLE;
+ (instancetype)FIELD;
+ (instancetype)VALUE_PARM;
+ (instancetype)VAR_PARM;
+ (instancetype)PROGRAM_PARM;
+ (instancetype)PROGRAM;
+ (instancetype)PROCEDURE;
+ (instancetype)FUNCTION;
+ (instancetype)UNDEFINED;

@end
