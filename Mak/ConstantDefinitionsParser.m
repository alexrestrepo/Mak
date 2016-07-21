//
//  ConstantDefinitionsParser.m
//  Mak
//
//  Created by Alex Restrepo on 7/24/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "ConstantDefinitionsParser.h"

#import "PascalTokenType.h"
#import "SymTabEntry.h"
#import "DefinitionImpl.h"
#import "SymTabKey.h"
#import "TypeSpec.h"
#import "SymTabKey.h"
#import "NSNumber+Type.h"
#import "Predefined.h"
#import "TypeFactory.h"

static NSSet <id<TokenType>> *IdentifierSet;
static NSSet <id<TokenType>> *ConstantStartSet;
static NSSet <id<TokenType>> *EqualsSet;
static NSSet <id<TokenType>> *NextStartSet;

@implementation ConstantDefinitionsParser

+ (void)initialize {
    if (self == [ConstantDefinitionsParser class]) {
        NSMutableSet *workingSet = [[DeclarationsParser typeStartSet] mutableCopy];
        [workingSet addObject:[PascalTokenType IDENTIFIER]];
        
        IdentifierSet = [workingSet copy];
        
        ConstantStartSet = [NSSet setWithArray:@[
                                                 [PascalTokenType IDENTIFIER],
                                                 [PascalTokenType INTEGER],
                                                 [PascalTokenType REAL],
                                                 [PascalTokenType PLUS],
                                                 [PascalTokenType MINUS],
                                                 [PascalTokenType STRING],
                                                 [PascalTokenType SEMICOLON],
                                                 ]];
        
        workingSet = [ConstantStartSet mutableCopy];
        [workingSet addObject:[PascalTokenType EQUALS]];
        [workingSet addObject:[PascalTokenType SEMICOLON]];
        EqualsSet = [workingSet copy];
        
        workingSet = [[DeclarationsParser typeStartSet] mutableCopy];
        [workingSet addObject:[PascalTokenType SEMICOLON]];
        [workingSet addObject:[PascalTokenType IDENTIFIER]];
        NextStartSet = [workingSet copy];
    }
}

+ (NSSet<id<TokenType>> *)constantStartSet {
    return ConstantStartSet;
}

// const ([const def] ;)+
// const def -> identifier = constant

- (void)parseToken:(Token *)token {
    token = [self synchronizeWithSet:IdentifierSet];
    while (token.type == [PascalTokenType IDENTIFIER]) {
        NSString *name = [token.text lowercaseString];
        SymTabEntry *constantId = [self.symbolTableStack lookupLocalTable:name];
        
        if (!constantId) {
            constantId = [self.symbolTableStack addEntryToLocalTable:name];
            [constantId appendLineNumber:token.lineNumber];
            
        } else {
            [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode IDENTIFIER_REDEFINED]];
            constantId = nil;
        }
        
        token = [self nextToken];
        token = [self synchronizeWithSet:EqualsSet];
        if (token.type == [PascalTokenType EQUALS]) {
            token = [self nextToken];
            
        } else {
            [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode MISSING_EQUALS]];
        }
        
        Token *constantToken = token;
        id value = [self parseConstantWithToken:token];
        
        if (constantId) {
            [constantId setDefinition:[DefinitionImpl CONSTANT]];
            [constantId setAttribute:value forKey:[SymTabKey CONSTANT_VALUE]];
            
            id<TypeSpec> constantType = (constantToken.type == [PascalTokenType IDENTIFIER]
                                         ? [self constantTypeForToken:constantToken]
                                         : [self constantTypeForValue:value]);
            [constantId setTypeSpec:constantType];
        }
        
        token = [self currentToken];
        id<TokenType> tokenType = token.type;
        
        // wut?
        if (tokenType == [PascalTokenType SEMICOLON]) {
            while (token.type == [PascalTokenType SEMICOLON]) {
                token = [self nextToken];
            }
        } else if ([NextStartSet containsObject:tokenType]) {
            [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode MISSING_SEMICOLON]];
        }
        
        token = [self synchronizeWithSet:IdentifierSet];
    }
}

- (id)parseConstantWithToken:(Token *)token {
    id<TokenType> sign = nil;
    
    token = [self synchronizeWithSet:ConstantStartSet];
    id<TokenType> tokenType = token.type;
    
    if (tokenType == [PascalTokenType PLUS] || tokenType == [PascalTokenType MINUS]) {
        sign = tokenType;
        token = [self nextToken];
        tokenType = token.type;
    }

    if (tokenType == [PascalTokenType IDENTIFIER]) {
        return [self parseIdentifierConstantWithToken:token sign:sign];
        
    } else if (tokenType == [PascalTokenType INTEGER]) {
        NSInteger value = [token.value integerValue];
        [self nextToken];
        return sign == [PascalTokenType MINUS] ? @(-value) : @(value);
        
    } else if (tokenType == [PascalTokenType REAL]) {
        CGFloat value = [token.value floatValue];
        [self nextToken];
        return sign == [PascalTokenType MINUS] ? @(-value) : @(value);
        
    } else if (tokenType == [PascalTokenType STRING]) {
        if (sign) {
            [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode INVALID_CONSTANT]];
        }
        
        [self nextToken];
        return token.value;
        
    } else {
        [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode INVALID_CONSTANT]];
    }
    
    return nil;
}

- (id)parseIdentifierConstantWithToken:(Token *)token sign:(id<TokenType>)sign {
    NSString *name = token.text;
    SymTabEntry *identifier =[self.symbolTableStack lookup:name];
    
    [self nextToken]; // consume the identifier
    
    if (!identifier) {
        [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode IDENTIFIER_UNDEFINED]];
        return nil;
    }
    
    id<Definition> definition = [identifier definition];
    if (definition == [DefinitionImpl CONSTANT]) {
        id value = [identifier attributeForKey:[SymTabKey CONSTANT_VALUE]];
        [identifier appendLineNumber:token.lineNumber];
        
        if ([value isKindOfClass:[NSString class]]) {
            if (sign) {
                [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode INVALID_CONSTANT]];
            }
            
            return value;
        }
        
        NSNumber *number = value;
        if ([number arg_isInteger]) {
            return sign == [PascalTokenType MINUS] ? @(-[number integerValue]) : number;
            
        } else {
            return sign == [PascalTokenType MINUS] ? @(-[number floatValue]) : number;
        }
        
    } else if (definition == [DefinitionImpl ENUMERATION_CONSTANT]) {
        id value = [identifier attributeForKey:[SymTabKey CONSTANT_VALUE]];
        [identifier appendLineNumber:token.lineNumber];
        
        if (sign) {
            [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode INVALID_CONSTANT]];
        }
        
        return value;
        
    } else if (!definition) {
        [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode NOT_CONSTANT_IDENTIFIER]];
        
    } else {
        [self.errorHandler flagToken:token withErrorCode:[PascalErrorCode INVALID_CONSTANT]];
    }
    
    return nil;
}

- (id<TypeSpec>)constantTypeForValue:(id)value {
    id<TypeSpec> constantType = nil;
    
    if ([value isKindOfClass:[NSString class]]) {
        if ([value length] == 1) {
            constantType = [Predefined charType];
            
        } else {
            constantType = [TypeFactory typeWithString:value];
        }
        
    } else {
        NSNumber *number = value;
        if ([number arg_isInteger]) {
            constantType = [Predefined integerType];
        } else {
            constantType = [Predefined realType];
        }
    }
    
    return constantType;
}

- (id<TypeSpec>)constantTypeForToken:(Token *)token {
    SymTabEntry *identifier = [self.symbolTableStack lookup:token.text];
    if (!identifier) {
        return nil;
    }
    
    id<Definition> definition = [identifier definition];
    if (definition == [DefinitionImpl CONSTANT] || definition == [DefinitionImpl ENUMERATION_CONSTANT]) {
        return [identifier typeSpec];
    }
    
    return nil;
}

@end
