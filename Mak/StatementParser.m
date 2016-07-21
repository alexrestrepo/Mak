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
#import "RepeatStatementParser.h"
#import "WhileStatementParser.h"
#import "ForStatementParser.h"
#import "IfStatementParser.h"
#import "CaseStatementParser.h"

static NSSet <id<TokenType>> *StmtStartSet;
static NSSet <id<TokenType>> *StmtFollowSet;

@implementation StatementParser

+ (void)initialize {
    if (self == [StatementParser class]) {
        StmtStartSet = [NSSet setWithArray:@[
                                             [PascalTokenType BEGIN],
                                             [PascalTokenType CASE],
                                             [PascalTokenType FOR],
                                             [PascalTokenType IDENTIFIER],
                                             [PascalTokenType IF],
                                             [PascalTokenType REPEAT],
                                             [PascalTokenType SEMICOLON],
                                             [PascalTokenType WHILE],
                                             ]];
        
        StmtFollowSet = [NSSet setWithArray:@[
                                             [PascalTokenType DOT],
                                             [PascalTokenType ELSE],
                                             [PascalTokenType END],
                                             [PascalTokenType SEMICOLON],
                                             [PascalTokenType UNTIL],
                                              ]];
    }
}

+ (NSSet <id<TokenType>> *)stmtStartSet {
    return StmtStartSet;
}

+ (NSSet <id<TokenType>> *)stmtFollowSet {
    return StmtFollowSet;
}

- (id<IntermediateCodeNode>)parseToken:(Token *)token {
    id<IntermediateCodeNode> statementNode = nil;
    
    if (token.type == [PascalTokenType BEGIN]) {
        CompoundStatementParser *compoundParser = [[CompoundStatementParser alloc] initWithParent:self];
        statementNode = [compoundParser parseToken:token];
        
    } else if (token.type == [PascalTokenType IDENTIFIER]) {
        AssignmentStatementParser *assignmentParser = [[AssignmentStatementParser alloc] initWithParent:self];
        statementNode = [assignmentParser parseToken:token];
        
    } else if (token.type == [PascalTokenType REPEAT]) {
        RepeatStatementParser *repeatParser = [[RepeatStatementParser alloc] initWithParent:self];
        statementNode = [repeatParser parseToken:token];
        
    } else if (token.type == [PascalTokenType WHILE]) {
        WhileStatementParser *whileParser = [[WhileStatementParser alloc] initWithParent:self];
        statementNode = [whileParser parseToken:token];
        
    } else if (token.type == [PascalTokenType FOR]) {
        ForStatementParser *forParser = [[ForStatementParser alloc] initWithParent:self];
        statementNode = [forParser parseToken:token];
        
    } else if (token.type == [PascalTokenType IF]) {
        IfStatementParser *ifParser = [[IfStatementParser alloc] initWithParent:self];
        statementNode = [ifParser parseToken:token];
        
    } else if (token.type == [PascalTokenType CASE]) {
        CaseStatementParser *caseParser = [[CaseStatementParser alloc] initWithParent:self];
        statementNode = [caseParser parseToken:token];
        
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
    
    NSMutableSet <id<TokenType>> *terminatorSet = [StmtStartSet mutableCopy];
    [terminatorSet addObject:terminator];
    
    while (!([token isKindOfClass:[EofToken class]])
           && (token.type != terminator)) {
        
        id<IntermediateCodeNode> statementNode = [self parseToken:token];
        [parentNode addChild:statementNode];
        
        token = [self currentToken];
        id<TokenType> tokenType = token.type;
        
        if (tokenType == [PascalTokenType SEMICOLON]) {
            token = [self nextToken]; // consume
            
        } else if ([StmtStartSet containsObject:tokenType]) {
            [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode MISSING_SEMICOLON]];
        }
        
        token = [self synchronizeWithSet:terminatorSet];
    }
    
    if (token.type == terminator) {
        token = [self nextToken];
        
    } else {
        [self.errorHandler flagToken:token withErrorCode:errorCode];
    }
}

@end
