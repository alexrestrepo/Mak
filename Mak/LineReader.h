//
//  LineReader.h
//  Mak
//
//  Created by Alex Restrepo on 5/13/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LineReader : NSObject

@property (nonatomic, strong, readonly) NSData *data;
@property (nonatomic, assign, readonly) NSUInteger linesRead;

@property (nonatomic, strong) NSCharacterSet *lineTrimCharacters;
@property (nonatomic, assign) NSStringEncoding stringEncoding;

- (instancetype)initWithFile:(NSString *)filePath encoding:(NSStringEncoding)encoding;
- (instancetype)initWithData:(NSData *)data encoding:(NSStringEncoding)encoding;
- (NSString *)readLine;
- (NSString *)readTrimmedLine;
- (void)setLineSearchPosition:(NSUInteger)position;

@end
