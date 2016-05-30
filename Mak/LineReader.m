//
//  LineReader.m
//  Mak
//
//  Created by Alex Restrepo on 5/13/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

// adapted from http://stackoverflow.com/questions/1044334/objective-c-reading-a-file-line-by-line

#import "LineReader.h"

static unsigned char const LineReaderDelimiter = '\n';

@interface LineReader ()

@property (nonatomic, assign) NSRange lastRange;

@end

@implementation LineReader

- (instancetype)initWithFile:(NSString *)filePath encoding:(NSStringEncoding)encoding
{
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedAlways error:&error];
    if (!data) {
        NSLog(@"%@", [error localizedDescription]);
        return nil;
    }
    
    return [self initWithData:data encoding:encoding];
}

- (instancetype)initWithData:(NSData *)data encoding:(NSStringEncoding)encoding
{
    self = [super init];
    if (self) {
        _data = data;
        _stringEncoding = encoding;
        _lineTrimCharacters = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    }
    
    return self;
}

- (NSString *)readLine
{
    NSUInteger dataLength = [_data length];
    NSUInteger beginPos = _lastRange.location + _lastRange.length;
    NSUInteger endPos = 0;
    
    if (beginPos == dataLength) {
        // End of file
        return nil;
    }
    
    unsigned char *buffer = (unsigned char *)[_data bytes];
    for (NSUInteger i = beginPos; i < dataLength; i++) {
        endPos = i;
        if (buffer[i] == LineReaderDelimiter) break;
    }
    
    // End of line found
    _lastRange = NSMakeRange(beginPos, endPos - beginPos); // don't add the \n
    NSData *lineData = [_data subdataWithRange:_lastRange];
    _lastRange.length++; // skip the \n
    NSString *line = [[NSString alloc] initWithData:lineData encoding:_stringEncoding];
    _linesRead++;
    
    return line;
}

- (NSString *)readTrimmedLine
{
    return [[self readLine] stringByTrimmingCharactersInSet:_lineTrimCharacters];
}

- (void)setLineSearchPosition:(NSUInteger)position
{
    _lastRange = NSMakeRange(position, 0);
    _linesRead = 0;
}

@end
