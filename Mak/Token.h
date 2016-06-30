//
//  Token.h
//  Mak
//
//  Created by Alex Restrepo on 5/13/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Source.h"

@protocol TokenType <NSObject, NSCopying>

@end

@interface Token : NSObject

@property (nonatomic, assign, readonly) NSInteger lineNumber;
@property (nonatomic, assign, readonly) NSInteger position;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) id<TokenType> type;
@property (nonatomic, strong) id value;

- (instancetype)initWithSource:(Source *)source;

- (void)extract;
- (NSString *)currentChar;
- (NSString *)nextChar;
- (NSString *)peekChar;

@end
