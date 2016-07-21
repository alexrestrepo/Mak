//
//  StatementParser.h
//  Mak
//
//  Created by Alex Restrepo on 6/29/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "PascalParserTD.h"

#import "IntermediateCode.h"
#import "PascalTokenType.h"
#import "PascalErrorCode.h"
#import "IntermediateCodeFactory.h"
#import "IntermediateCodeNodeTypeImp.h"
#import "IntermediateCodeKeyImp.h"
#import "EofToken.h"

@interface StatementParser : PascalParserTD

+ (NSSet <id<TokenType>> *)stmtFollowSet;
+ (NSSet <id<TokenType>> *)stmtStartSet;
- (id<IntermediateCodeNode>)parseToken:(Token *)token;
- (void)setLineNumberInNode:(id<IntermediateCodeNode>)node forToken:(Token *)token;
- (void)parseListFromToken:(Token *)token
                parentNode:(id<IntermediateCodeNode>)parentNode
                terminator:(PascalTokenType *)terminator
                 errorCode:(PascalErrorCode *)errorCode;

@end
