//
//  Token.m
//  Mak
//
//  Created by Alex Restrepo on 5/13/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "Token.h"

@interface Token ()

@property (nonatomic, strong) id<TokenType> type;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) id value;
@property (nonatomic, strong) Source *source;
@property (nonatomic, assign) NSInteger lineNumber;
@property (nonatomic, assign) NSInteger position;

@end

@implementation Token

- (instancetype)initWithSource:(Source *)source
{
    self = [super init];
    if (self) {
        _source = source;
        _lineNumber = source.lineNumber;
        _position = source.currentPosition;
        
        [self extract];
    }
    return self;
}

- (void)extract
{
    _text = [self currentChar];
    _value = nil;
    
    [self nextChar];
}

- (NSString *)currentChar
{
    return [_source currentChar];
}

- (NSString *)nextChar
{
    return [_source nextChar];
}

- (NSString *)peekChar
{
    return [_source peekChar];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"[%@][%ld:%ld]", _text, (long)_lineNumber, (long)_position];
}

@end
