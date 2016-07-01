//
//  ExpressionExecutor.m
//  Mak
//
//  Created by Alex Restrepo on 6/30/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "ExpressionExecutor.h"

#import "NSNumber+Type.h"

#import "IntermediateCodeNodeTypeImp.h"
#import "IntermediateCodeKeyImp.h"
#import "SymTabEntry.h"
#import "SymTabKey.h"

static NSArray <IntermediateCodeNodeTypeImp *> *ArithmeticOps;

@implementation ExpressionExecutor

+ (void)initialize {
    if (self == [ExpressionExecutor class]) {
        ArithmeticOps = @[[IntermediateCodeNodeTypeImp ADD],
                          [IntermediateCodeNodeTypeImp SUBTRACT],
                          [IntermediateCodeNodeTypeImp MULTIPLY],
                          [IntermediateCodeNodeTypeImp FLOAT_DIVIDE],
                          [IntermediateCodeNodeTypeImp INTEGER_DIVIDE]];
    }
}

- (id)executeNode:(id<IntermediateCodeNode>)node {
    id<IntermediateCodeNodeType> nodeType = node.type;
    
    id value = nil;
    
    if (nodeType == [IntermediateCodeNodeTypeImp VARIABLE]) {
        SymTabEntry *entry = [node attributeForKey:[IntermediateCodeKeyImp ID]];
        value = [entry attributeForKey:[SymTabKey DATA_VALUE]];
        
    } else if (nodeType == [IntermediateCodeNodeTypeImp INTEGER_CONSTANT]) {
        value = [node attributeForKey:[IntermediateCodeKeyImp VALUE]];
        
    } else if (nodeType == [IntermediateCodeNodeTypeImp REAL_CONSTANT]) {
        value = [node attributeForKey:[IntermediateCodeKeyImp VALUE]];
        
    } else if (nodeType == [IntermediateCodeNodeTypeImp STRING_CONSTANT]) {
        value = [node attributeForKey:[IntermediateCodeKeyImp VALUE]];
        
    } else if (nodeType == [IntermediateCodeNodeTypeImp NEGATE]) {
        NSArray <id<IntermediateCodeNode>> *children = [node children];
        id<IntermediateCodeNode> expression = children[0];
        value = [self executeNode:expression];
        
        if ([value isKindOfClass:[NSNumber class]]) {
            value = @(-[value doubleValue]);
        }
        
    } else if (nodeType == [IntermediateCodeNodeTypeImp NOT]) {
        NSArray <id<IntermediateCodeNode>> *children = [node children];
        id<IntermediateCodeNode> expression = children[0];
        value = [self executeNode:expression];
        
        if ([value isKindOfClass:[NSValue class]]) {
            value = @(![value boolValue]);
        }
        
    } else  {
        value = [self executeBinaryOperatorWithNode:node type:nodeType];
    }
    
    return value;
}

- (id)executeBinaryOperatorWithNode:(id<IntermediateCodeNode>)node type:(id<IntermediateCodeNodeType>)nodeType {
    NSArray <id<IntermediateCodeNode>> *children = [node children];
    id<IntermediateCodeNode> left = children[0];
    id<IntermediateCodeNode> right = children[1];
    
    id leftOperand = [self executeNode:left];
    id rightOperand = [self executeNode:right];
    
    const BOOL leftIsInteger = [leftOperand isKindOfClass:[NSNumber class]] && [leftOperand arg_isInteger];
    const BOOL rightIsInteger = [rightOperand isKindOfClass:[NSNumber class]] && [rightOperand arg_isInteger];
    const BOOL integerMode = leftIsInteger && rightIsInteger;
    
    id calculatedValue = @(0);
    
    if ([ArithmeticOps containsObject:nodeType]) {
        if (integerMode) {
            const NSInteger leftValue = [leftOperand integerValue];
            const NSInteger rightValue = [rightOperand integerValue];
            
            if (nodeType == [IntermediateCodeNodeTypeImp ADD]) {
                calculatedValue = @(leftValue + rightValue);
                
            } else if (nodeType == [IntermediateCodeNodeTypeImp SUBTRACT]) {
                calculatedValue = @(leftValue - rightValue);
                
            } else if (nodeType == [IntermediateCodeNodeTypeImp MULTIPLY]) {
                calculatedValue = @(leftValue * rightValue);
                
            } else if (nodeType == [IntermediateCodeNodeTypeImp FLOAT_DIVIDE]) {
                if (rightValue == 0) {
                    [self.errorHandler flagNode:node withErrorCode:[RuntimeErrorCode DIVISION_BY_ZERO]];
                    
                } else {
                    calculatedValue = @((float)leftValue / (float)rightValue);
                }
                
            } else if (nodeType == [IntermediateCodeNodeTypeImp INTEGER_DIVIDE]) {
                if (rightValue == 0) {
                    [self.errorHandler flagNode:node withErrorCode:[RuntimeErrorCode DIVISION_BY_ZERO]];
                    
                } else {
                    calculatedValue = @(leftValue / rightValue);
                }
                
            } else if (nodeType == [IntermediateCodeNodeTypeImp MOD]) {
                if (rightValue == 0) {
                    [self.errorHandler flagNode:node withErrorCode:[RuntimeErrorCode DIVISION_BY_ZERO]];
                    
                } else {
                    calculatedValue = @(leftValue % rightValue);
                }
                
            }
            
        } else { // float mode?
            const CGFloat leftValue = leftIsInteger ? [leftOperand integerValue] : [leftOperand floatValue];
            const CGFloat rightValue = rightIsInteger ? [rightOperand integerValue] : [rightOperand floatValue];
            
            if (nodeType == [IntermediateCodeNodeTypeImp ADD]) {
                calculatedValue = @(leftValue + rightValue);
                
            } else if (nodeType == [IntermediateCodeNodeTypeImp SUBTRACT]) {
                calculatedValue = @(leftValue - rightValue);
                
            } else if (nodeType == [IntermediateCodeNodeTypeImp MULTIPLY]) {
                calculatedValue = @(leftValue * rightValue);
                
            } else if (nodeType == [IntermediateCodeNodeTypeImp FLOAT_DIVIDE]) {
                if (ABS(rightValue) < FLT_EPSILON) {
                    [self.errorHandler flagNode:node withErrorCode:[RuntimeErrorCode DIVISION_BY_ZERO]];
                    
                } else {
                    calculatedValue = @(leftValue / rightValue);
                }
            }
        }
    } else if (nodeType == [IntermediateCodeNodeTypeImp AND] || nodeType == [IntermediateCodeNodeTypeImp OR]) {
        const BOOL leftValue = [leftOperand boolValue];
        const BOOL rightValue = [rightOperand boolValue];
        
        if (nodeType == [IntermediateCodeNodeTypeImp AND]) {
            calculatedValue = @(leftValue && rightValue);
            
        } else if (nodeType == [IntermediateCodeNodeTypeImp OR]) {
            calculatedValue = @(leftValue || rightValue);
            
        }
    } else if (integerMode) {
        const NSInteger leftValue = [leftOperand integerValue];
        const NSInteger rightValue = [rightOperand integerValue];
        
        if (nodeType == [IntermediateCodeNodeTypeImp EQ]) {
            calculatedValue = @(leftValue == rightValue);
            
        } else if (nodeType == [IntermediateCodeNodeTypeImp NE]) {
            calculatedValue = @(leftValue != rightValue);
            
        } else if (nodeType == [IntermediateCodeNodeTypeImp LT]) {
            calculatedValue = @(leftValue < rightValue);
            
        } else if (nodeType == [IntermediateCodeNodeTypeImp LE]) {
            calculatedValue = @(leftValue <= rightValue);
            
        } else if (nodeType == [IntermediateCodeNodeTypeImp GT]) {
            calculatedValue = @(leftValue > rightValue);
            
        } else if (nodeType == [IntermediateCodeNodeTypeImp GE]) {
            calculatedValue = @(leftValue >= rightValue);
        }
        
    } else {
        const CGFloat leftValue = leftIsInteger ? [leftOperand integerValue] : [leftOperand floatValue];
        const CGFloat rightValue = rightIsInteger ? [rightOperand integerValue] : [rightOperand floatValue];
        
        if (nodeType == [IntermediateCodeNodeTypeImp EQ]) {
            calculatedValue = @(leftValue == rightValue);
            
        } else if (nodeType == [IntermediateCodeNodeTypeImp NE]) {
            calculatedValue = @(leftValue != rightValue);
            
        } else if (nodeType == [IntermediateCodeNodeTypeImp LT]) {
            calculatedValue = @(leftValue < rightValue);
            
        } else if (nodeType == [IntermediateCodeNodeTypeImp LE]) {
            calculatedValue = @(leftValue <= rightValue);
            
        } else if (nodeType == [IntermediateCodeNodeTypeImp GT]) {
            calculatedValue = @(leftValue > rightValue);
            
        } else if (nodeType == [IntermediateCodeNodeTypeImp GE]) {
            calculatedValue = @(leftValue >= rightValue);
        }
    }
    
    return calculatedValue;
}

@end
