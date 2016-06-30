//
//  StatementParser.m
//  Mak
//
//  Created by Alex Restrepo on 6/29/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "StatementParser.h"

#import "AssignmentStatementParser.h"
#import "CompoundStatementParser.h"

@implementation StatementParser

- (id<IntermediateCodeNode>)parseToken:(Token *)token {
    id<IntermediateCodeNode> statementNode = nil;
    
    if (token.type == [PascalTokenType BEGIN]) {
        CompoundStatementParser *compoundParser = [[CompoundStatementParser alloc] initWithParent:self];
        statementNode = [compoundParser parseToken:token];
        
    } else if (token.type == [PascalTokenType IDENTIFIER]) {
        AssignmentStatementParser *assignmentParser = [[AssignmentStatementParser alloc] initWithParent:self];
        statementNode = [assignmentParser parseToken:token];
        
    } else {
        statementNode = [IntermediateCodeFactory intermediateCodeNodeWithType:[IntermediateCodeNodeTypeImp NO_OP]];
    }
    
    [self setLineNumberInNode:statementNode forToken:token];
    return statementNode;
}

- (void)setLineNumberInNode:(id<IntermediateCodeNode>)node forToken:(Token *)token {
    [node setAttribute:@(token.lineNumber) forKey:[IntermediateCodeKeyImp LINE]];
}

- (void)parseListFromToken:(Token *)token
                parentNode:(id<IntermediateCodeNode>)parentNode
                terminator:(PascalTokenType *)terminator
                 errorCode:(PascalErrorCode *)errorCode {
    
    while (!([token isKindOfClass:[EofToken class]])
           && (token.type != terminator)) {
        
        id<IntermediateCodeNode> statementNode = [self parseToken:token];
        [parentNode addChild:statementNode];
        
        token = [self currentToken];
        id<TokenType> tokenType = token.type;
        
        if (tokenType == [PascalTokenType SEMICOLON]) {
            token = [self nextToken]; // consume
            
        } else if (tokenType == [PascalTokenType IDENTIFIER]) {
            [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode MISSING_SEMICOLON]];
            
        } else if (tokenType != terminator) {
            [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode UNEXPECTED_TOKEN]];
            token = [self nextToken];
        }
    }
    
    if (token.type == terminator) {
        token = [self nextToken];
        
    } else {
        [self.errorHandler flagToken:token withErrorCode:errorCode];
    }
}

@end
