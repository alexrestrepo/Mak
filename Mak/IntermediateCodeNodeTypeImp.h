//
//  IntermediateCodeNodeTypeImp.h
//  Mak
//
//  Created by Alex Restrepo on 6/29/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IntermediateCode.h"

@interface IntermediateCodeNodeTypeImp : NSObject <IntermediateCodeNodeType>

@property (nonatomic, assign, readonly) NSInteger ordinal;
@property (nonatomic, copy, readonly) NSString *name;

+ (instancetype)PROGRAM;
+ (instancetype)PROCEDURE;
+ (instancetype)FUNCTION;
+ (instancetype)COMPOUND;
+ (instancetype)ASSIGN;
+ (instancetype)LOOP;
+ (instancetype)TEST;
+ (instancetype)CALL;
+ (instancetype)PARAMETERS;
+ (instancetype)IF;
+ (instancetype)SELECT;
+ (instancetype)SELECT_BRANCH;
+ (instancetype)SELECT_CONSTANTS;
+ (instancetype)NO_OP;
+ (instancetype)EQ;
+ (instancetype)NE;
+ (instancetype)LT;
+ (instancetype)LE;
+ (instancetype)GT;
+ (instancetype)GE;
+ (instancetype)NOT;
+ (instancetype)ADD;
+ (instancetype)SUBTRACT;
+ (instancetype)OR;
+ (instancetype)NEGATE;
+ (instancetype)MULTIPLY;
+ (instancetype)INTEGER_DIVIDE;
+ (instancetype)FLOAT_DIVIDE;
+ (instancetype)MOD;
+ (instancetype)AND;
+ (instancetype)VARIABLE;
+ (instancetype)SUBSCRIPTS;
+ (instancetype)FIELD;
+ (instancetype)INTEGER_CONSTANT;
+ (instancetype)REAL_CONSTANT;
+ (instancetype)STRING_CONSTANT;
+ (instancetype)BOOLEAN_CONSTANT;
+ (instancetype)WRITE_PARM;

@end
