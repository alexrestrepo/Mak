//
//  Scanner.m
//  Mak
//
//  Created by Alex Restrepo on 5/13/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "Scanner.h"

#import "Macros.h"
#import "Source.h"
#import "Token.h"

@interface Scanner ()

@property (nonatomic, strong) Source *source;
@property (nonatomic, strong) Token *currentToken;

@end

@implementation Scanner

- (instancetype)initWithSource:(Source *)source
{
    self = [super init];
    if (self) {
        _source = source;
    }
    return self;
}

- (Token *)currentToken
{
    return _currentToken;
}

- (Token *)nextToken
{
    _currentToken = [self extractToken];
    return _currentToken;
}

- (Token *)extractToken AR_ABSTRACT_METHOD;

- (NSString *)currentChar
{
    return [_source currentChar];
}

- (NSString *)nextChar
{
    return [_source nextChar];
}

@end
