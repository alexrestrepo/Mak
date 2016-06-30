//
//  ExpressionParser.m
//  Mak
//
//  Created by Alex Restrepo on 6/30/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "ExpressionParser.h"

#import "SymTabStack.h"
#import "SymTab.h"
#import "SymTabEntry.h"

static NSSet <PascalTokenType *> *Relops;
static NSDictionary <PascalTokenType *, id<IntermediateCodeNodeType>> *RelopMap;

static NSSet <PascalTokenType *> *Addops;
static NSDictionary <PascalTokenType *, id<IntermediateCodeNodeType>> *AddopMap;

static NSSet <PascalTokenType *> *Multops;
static NSDictionary <PascalTokenType *, id<IntermediateCodeNodeType>> *MultopMap;

@implementation ExpressionParser

+ (void)initialize {
    if (self == [ExpressionParser class]) {
        Relops = [NSSet setWithArray:@[[PascalTokenType EQUALS],
                                       [PascalTokenType NOT_EQUALS],
                                       [PascalTokenType LESS_THAN],
                                       [PascalTokenType LESS_EQUALS],
                                       [PascalTokenType GREATER_THAN],
                                       [PascalTokenType GREATER_EQUALS]]];
        
        RelopMap = @{[PascalTokenType EQUALS]:[IntermediateCodeNodeTypeImp EQ],
                     [PascalTokenType NOT_EQUALS]:[IntermediateCodeNodeTypeImp NE],
                     [PascalTokenType LESS_THAN]:[IntermediateCodeNodeTypeImp LT],
                     [PascalTokenType LESS_EQUALS]:[IntermediateCodeNodeTypeImp LE],
                     [PascalTokenType GREATER_THAN]:[IntermediateCodeNodeTypeImp GT],
                     [PascalTokenType GREATER_EQUALS]:[IntermediateCodeNodeTypeImp GE]};
        
        Addops = [NSSet setWithArray:@[[PascalTokenType PLUS],
                                       [PascalTokenType MINUS],
                                       [PascalTokenType OR]]];
        
        AddopMap = @{[PascalTokenType PLUS]:[IntermediateCodeNodeTypeImp ADD],
                     [PascalTokenType MINUS]:[IntermediateCodeNodeTypeImp SUBTRACT],
                     [PascalTokenType OR]:[IntermediateCodeNodeTypeImp OR],};
        
        
        Multops = [NSSet setWithArray:@[[PascalTokenType STAR],
                                        [PascalTokenType SLASH],
                                        [PascalTokenType DIV],
                                        [PascalTokenType MOD],
                                        [PascalTokenType AND]]];
        
        MultopMap = @{[PascalTokenType STAR]:[IntermediateCodeNodeTypeImp MULTIPLY],
                      [PascalTokenType SLASH]:[IntermediateCodeNodeTypeImp FLOAT_DIVIDE],
                      [PascalTokenType DIV]:[IntermediateCodeNodeTypeImp INTEGER_DIVIDE],
                      [PascalTokenType MOD]:[IntermediateCodeNodeTypeImp MOD],
                      [PascalTokenType AND]:[IntermediateCodeNodeTypeImp AND]};
    }
}

- (id<IntermediateCodeNode>)parseToken:(Token *)token {
    return [self parseExpressionWithToken:token];
}

- (id<IntermediateCodeNode>)parseExpressionWithToken:(Token *)token {
    id<IntermediateCodeNode> rootNode = [self parseSimpleExpressionWithToken:token];
    
    token = [self currentToken];
    id<TokenType> tokenType = token.type;
    
    if ([Relops containsObject:tokenType]) {
        id<IntermediateCodeNodeType> nodeType = [RelopMap objectForKey:tokenType];
        id<IntermediateCodeNode> opNode = [IntermediateCodeFactory intermediateCodeNodeWithType:nodeType];
        [opNode addChild:rootNode];
        
        token = [self nextToken];
        
        [opNode addChild:[self parseSimpleExpressionWithToken:token]];
        
        rootNode = opNode;
    }
    
    return rootNode;
}

- (id<IntermediateCodeNode>)parseSimpleExpressionWithToken:(Token *)token {
    id<TokenType> signType = nil;
    
    id<TokenType> tokenType = token.type;
    if (tokenType == [PascalTokenType PLUS] || tokenType == [PascalTokenType MINUS]) {
        signType = tokenType;
        token = [self nextToken]; // consume leading sign
    }
    
    id<IntermediateCodeNode> rootNode = [self parseTermWithToken:token];
    if (signType == [PascalTokenType MINUS]) {
        // leading -?
        id<IntermediateCodeNode> negateNode = [IntermediateCodeFactory intermediateCodeNodeWithType:[IntermediateCodeNodeTypeImp NEGATE]];
        [negateNode addChild:rootNode];
        rootNode = negateNode;
    }
    
    token = [self currentToken];
    tokenType = token.type;
    
    while ([Addops containsObject:tokenType]) {
        id<IntermediateCodeNodeType> nodeType = [AddopMap objectForKey:tokenType];
        id<IntermediateCodeNode> opNode = [IntermediateCodeFactory intermediateCodeNodeWithType:nodeType];
        [opNode addChild:rootNode];
        
        token = [self nextToken];
        [opNode addChild:[self parseTermWithToken:token]];
        
        rootNode = opNode;
        token = [self currentToken];
        tokenType = token.type;
    }
    
    return rootNode;
}

- (id<IntermediateCodeNode>)parseTermWithToken:(Token *)token {
    id<IntermediateCodeNode> rootNode = [self parseFactorWithToken:token];
    
    token = [self currentToken];
    id<TokenType> tokenType = token.type;
    
    while ([Multops containsObject:tokenType]) {
        id<IntermediateCodeNodeType> nodeType = [MultopMap objectForKey:tokenType];
        id<IntermediateCodeNode> opNode = [IntermediateCodeFactory intermediateCodeNodeWithType:nodeType];
        [opNode addChild:rootNode];
        
        token = [self nextToken];
        [opNode addChild:[self parseFactorWithToken:token]];
        
        rootNode = opNode;
        token = [self currentToken];
        tokenType = token.type;
    }
    
    return rootNode;
}

- (id<IntermediateCodeNode>)parseFactorWithToken:(Token *)token {
    id<TokenType> tokenType = token.type;
    id<IntermediateCodeNode> rootNode = nil;
    
    if (tokenType == [PascalTokenType IDENTIFIER]) {
        NSString *name = [token.text lowercaseString];
        SymTabEntry *identifier = [self.symbolTableStack lookup:name];
        if (!identifier) {
            [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode IDENTIFIER_UNDEFINED]];
            identifier = [self.symbolTableStack addEntryToLocalTable:name];
        }
        rootNode = [IntermediateCodeFactory intermediateCodeNodeWithType:[IntermediateCodeNodeTypeImp VARIABLE]];
        [rootNode setAttribute:identifier forKey:[IntermediateCodeKeyImp ID]];
        [identifier appendLineNumber:token.lineNumber];
        
        token = [self nextToken];
        
    } else if (tokenType == [PascalTokenType INTEGER]) {
        rootNode = [IntermediateCodeFactory intermediateCodeNodeWithType:[IntermediateCodeNodeTypeImp INTEGER_CONSTANT]];
        [rootNode setAttribute:token.value forKey:[IntermediateCodeKeyImp VALUE]];
        
        token = [self nextToken];
        
    } else if (tokenType == [PascalTokenType REAL]) {
        rootNode = [IntermediateCodeFactory intermediateCodeNodeWithType:[IntermediateCodeNodeTypeImp REAL_CONSTANT]];
        [rootNode setAttribute:token.value forKey:[IntermediateCodeKeyImp VALUE]];
        
        token = [self nextToken];
        
    } else if (tokenType == [PascalTokenType STRING]) {
        rootNode = [IntermediateCodeFactory intermediateCodeNodeWithType:[IntermediateCodeNodeTypeImp STRING_CONSTANT]];
        [rootNode setAttribute:token.value forKey:[IntermediateCodeKeyImp VALUE]];
        
        token = [self nextToken];
        
        
    } else if (tokenType == [PascalTokenType NOT]) {
        token = [self nextToken]; //consume not
        
        rootNode = [IntermediateCodeFactory intermediateCodeNodeWithType:[IntermediateCodeNodeTypeImp NOT]];
        [rootNode addChild:[self parseFactorWithToken:token]];
        
    } else if (tokenType == [PascalTokenType LEFT_PAREN]) {
        token = [self nextToken]; // consume (
        
        rootNode = [self parseExpressionWithToken:token];
        token = [self currentToken];
        
        if (token.type == [PascalTokenType RIGHT_PAREN]) {
            token = [self nextToken]; //consume )
            
        } else {
            [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode MISSING_RIGHT_PAREN]];
        }
        
    } else {
        [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode UNEXPECTED_TOKEN]];
        
    }
    
    return rootNode;
}

@end
