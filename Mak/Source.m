//
//  Source.m
//  Mak
//
//  Created by Alex Restrepo on 5/13/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "Source.h"

#import "LineReader.h"
#import "Message.h"

NSString *const EndOfLine = @"\n";
NSString *const EndOfFile = @"";

@interface Source ()

@property (nonatomic, strong) LineReader *lineReader;
@property (nonatomic, copy) NSString *currentLine;
@property (nonatomic, assign) NSInteger lineNumber;
@property (nonatomic, assign) NSInteger currentPosition;

@end

@implementation Source

- (instancetype)initWithLineReader:(LineReader *)lineReader
{
    self = [super init];
    if (self) {
        _lineNumber = 0;
        _currentPosition = NSNotFound; // set to -2 to read the first line?
        _lineReader = lineReader;
    }
    return self;
}

// return the source char at the current pos
- (NSString *)currentChar
{
    if (_currentPosition == NSNotFound) {
        // first time
        [self readLine];
        return [self nextChar];
        
    } else if (!_currentLine) {
        // eof
        return EndOfFile;
        
    } else if (_currentPosition == -1 || _currentPosition == [_currentLine length]) {
        // eol
        return EndOfLine;
        
    } else if (_currentPosition > [_currentLine length]) {
        [self readLine];
        return [self nextChar];
    }
    
    NSString *current = [_currentLine substringWithRange:NSMakeRange(_currentPosition, 1)];
    return current;
}

// consume the current char and return the next one
- (NSString *)nextChar
{
    ++_currentPosition;
    return [self currentChar];
}

// return the source char followinf the current without consiming the current
- (NSString *)peekChar
{
    [self currentChar];
    if (!_currentLine) {
        return EndOfLine;
    }
    
    NSInteger nextPos = _currentPosition + 1;
    return nextPos < [_currentLine length] ? [_currentLine substringWithRange:NSMakeRange(nextPos, 1)] : EndOfLine;
}

// read the next source line
- (void)readLine
{
    _currentLine = [_lineReader readLine];
    _currentPosition = -1;
    
    if (_currentLine) {
        ++_lineNumber;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:SourceEventNotificationName
                                                            object:[Message messageWithType:MessageTypeSourceLine
                                                                                       body:@[@(_lineNumber), _currentLine]]];
    }
}

- (void)close
{
    self.lineReader = nil;
}

@end
