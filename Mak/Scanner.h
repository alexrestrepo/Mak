//
//  Scanner.h
//  Mak
//
//  Created by Alex Restrepo on 5/13/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Source;
@class Token;

@interface Scanner : NSObject

@property (nonatomic, strong, readonly) Source *source;
@property (nonatomic, strong, readonly) Token *currentToken;

- (instancetype)initWithSource:(Source *)source;
- (Token *)currentToken;
- (Token *)nextToken;

- (Token *)extractToken; // must be implemented in a subclass
- (NSString *)currentChar;
- (NSString *)nextChar;

@end
