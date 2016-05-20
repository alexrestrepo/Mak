//
//  Source.h
//  Mak
//
//  Created by Alex Restrepo on 5/13/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const EndOfLine;
extern NSString *const EndOfFile;

@class LineReader;

@interface Source : NSObject

@property (nonatomic, assign, readonly) NSInteger lineNumber;
@property (nonatomic, assign, readonly) NSInteger currentPosition;

- (instancetype)initWithLineReader:(LineReader *)lineReader;
- (NSString *)currentChar;
- (NSString *)nextChar;
- (NSString *)peekChar;
- (void)close;

@end
