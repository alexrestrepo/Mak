//
//  BlockParser.m
//  Mak
//
//  Created by Alex Restrepo on 7/22/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "BlockParser.h"

#import "DeclarationsParser.h"
#import "StatementParser.h"
#import "PascalTokenType.h"
#import "IntermediateCodeFactory.h"
#import "IntermediateCodeNodeTypeImp.h"

@implementation BlockParser

- (id<IntermediateCodeNode>)parseToken:(Token *)token routineEntry:(id<SymbolTableEntry>)entry {
    DeclarationsParser *declarationsParser = [[DeclarationsParser alloc] initWithParent:self];
    StatementParser *statementParser = [[StatementParser alloc] initWithParent:self];
    
    [declarationsParser parseToken:token];
    token = [self synchronizeWithSet:[StatementParser stmtStartSet]];
    
    id<TokenType> type = token.type;
    id<IntermediateCodeNode> rootNode = nil;
    
    if (type == [PascalTokenType BEGIN]) {
        rootNode = [statementParser parseToken:token];
        
    } else {
        [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode MISSING_BEGIN]];
        
        if ([[StatementParser stmtStartSet] containsObject:type]) {
            rootNode = [IntermediateCodeFactory intermediateCodeNodeWithType:[IntermediateCodeNodeTypeImp COMPOUND]];
            [statementParser parseListFromToken:token parentNode:rootNode terminator:[PascalTokenType END] errorCode:[PascalErrorCode MISSING_END]];
            
        }
    }
    
    return rootNode;
}

@end
