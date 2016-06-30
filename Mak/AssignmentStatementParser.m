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

@implementation AssignmentStatementParser

- (id<IntermediateCodeNode>)parseToken:(Token *)token {
    id<IntermediateCodeNode> assignNode = [IntermediateCodeFactory intermediateCodeNodeWithType:[IntermediateCodeNodeTypeImp ASSIGN]];
    NSString *targetName = [token.text lowercaseString];
    SymTabEntry *targetID = [self.symbolTableStack lookup:targetName];
    
    if (!targetID) {
        targetID = [self.symbolTableStack addEntryToLocalTable:targetName];
    }
    [targetID appendLineNumber:token.lineNumber];
    
    token = [self nextToken]; // consume the identifier
    id<IntermediateCodeNode> variableNode = [IntermediateCodeFactory intermediateCodeNodeWithType:[IntermediateCodeNodeTypeImp VARIABLE]];
    [variableNode setAttribute:targetID forKey:[IntermediateCodeKeyImp ID]];
    
    [assignNode addChild:variableNode];
    if (token.type == [PascalTokenType COLON_EQUALS]) {
        token = [self nextToken];
        
    } else {
        [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode MISSING_COLON_EQUALS]];
    }
    
    ExpressionParser *expressionParser = [[ExpressionParser alloc] initWithParent:self];
    [assignNode addChild:[expressionParser parseToken:token]];
    
    return assignNode;
}

@end
