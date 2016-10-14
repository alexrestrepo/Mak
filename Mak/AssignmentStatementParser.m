//
//  AssignmentStatementParser.m
//  Mak
//
//  Created by Alex Restrepo on 6/29/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "AssignmentStatementParser.h"

#import "SymTabEntry.h"
#import "SymbolTableStack.h"
#import "ExpressionParser.h"
#import "VariableParser.h"
#import "Predefined.h"
#import "TypeChecker.h"

static NSSet <id<TokenType>> *ColonEqualsSet;

@implementation AssignmentStatementParser

+ (void)initialize {
    if (self == [AssignmentStatementParser class]) {
        NSMutableArray *allObjects = [[[ExpressionParser exprStartSet] allObjects] mutableCopy];
        [allObjects addObject:[PascalTokenType COLON_EQUALS]];
        [allObjects addObjectsFromArray:[[StatementParser stmtFollowSet] allObjects]];
        ColonEqualsSet = [NSSet setWithArray:allObjects];
    }
}

- (id<IntermediateCodeNode>)parseToken:(Token *)token {
    id<IntermediateCodeNode> assignNode = [IntermediateCodeFactory intermediateCodeNodeWithType:[IntermediateCodeNodeTypeImp ASSIGN]];

    VariableParser *variableParser = [[VariableParser alloc] initWithParent:self];
    id<IntermediateCodeNode> targetNode = [variableParser parseToken:token];
    id<TypeSpec> targetType = targetNode ? [targetNode typeSpec] : [Predefined undefinedType];

    [assignNode addChild:targetNode];
    token = [self synchronizeWithSet:ColonEqualsSet];
    if (token.type == [PascalTokenType COLON_EQUALS]) {
        token = [self nextToken];

    } else {
        [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode MISSING_COLON_EQUALS]];
    }

    ExpressionParser *expressionParser = [[ExpressionParser alloc] initWithParent:self];
    id<IntermediateCodeNode> expressionNode = [expressionParser parseToken:token];
    [assignNode addChild:expressionNode];

    id<TypeSpec> expressionType = expressionNode ? [expressionNode typeSpec] : [Predefined undefinedType];
    if (![TypeChecker areAssignmentCompatibleTarget:targetType value:expressionType]) {
        [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode INCOMPATIBLE_TYPES]];
    }

    [assignNode setTypeSpec:targetType];
    return assignNode;
}

@end
