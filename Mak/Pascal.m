//
//  Pascal.m
//  Mak
//
//  Created by Alex Restrepo on 5/19/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "Pascal.h"

#import "CodeGenerator.h"
#import "Executor.h"
#import "IntermediateCode.h"
#import "LineReader.h"
#import "Macros.h"
#import "Message.h"
#import "Notifications.h"
#import "PascalParserTD.h"
#import "PascalScanner.h"
#import "Source.h"
#import "SymbolTableStack.h"
#import "CrossReferencer.h"
#import "ParseTreePrinter.h"

@interface Pascal ()

@property (nonatomic, strong) Parser *parser;
@property (nonatomic, strong) Source *source;
@property (nonatomic, strong) Backend *backend;
@property (nonatomic, strong) id<IntermediateCode> intermediateCode;
@property (nonatomic, strong) id<SymbolTableStack> symbolTableStack;

@end

@implementation Pascal

- (instancetype)initWithOperation:(NSString *)operation path:(NSString *)path flags:(NSString *)flags {
    self = [super init];
    if (self) {
        const BOOL intermediate = [flags containsString:@"i"];
        const BOOL xref = [flags containsString:@"x"];
        
        DebugLog(@"source:%@ i:%@ x:%@", path, intermediate ? @"YES" : @"NO", xref ? @"YES" : @"NO");

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onMessage:)
                                                     name:SourceEventNotificationName
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onMessage:)
                                                     name:ParserEventNotificationName
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onMessage:)
                                                     name:BackendEventNotificationName
                                                   object:nil];
        
        LineReader *lineReader = [[LineReader alloc] initWithFile:path
                                                         encoding:NSUTF8StringEncoding];
        NSAssert(lineReader, @"no file?");
        _source = [[Source alloc] initWithLineReader:lineReader];
        
        Scanner *scanner = [[PascalScanner alloc] initWithSource:_source];
        _parser = [[PascalParserTD alloc] initWithScanner:scanner];
        
        if ([operation isEqualToString:@"compile"]) {
            _backend = [CodeGenerator new];
            
        } else if ([operation isEqualToString:@"execute"]) {
            _backend = [Executor new];
            
        } else {
            
        }
        
        [_parser parse];
        [_source close];
        
        _intermediateCode = _parser.intermediateCode;
        _symbolTableStack = _parser.symbolTableStack;
        
        if (xref) {
            CrossReferencer *xreferencer = [CrossReferencer new];
            [xreferencer printSymbolTableStack:_symbolTableStack];
        }
        
        if (intermediate) {
            ParseTreePrinter *printer = [[ParseTreePrinter alloc] init];
            NSString *dump = [printer stringFromIntermediateCode:_intermediateCode];
            printf("%s", [dump UTF8String]);
        }
        
        [_backend processWithIntermediateCode:_intermediateCode table:_symbolTableStack];
    }
    return self;
}

- (void)onMessage:(NSNotification *)note {
    Message *message = note.object;
    NSString *messageString = [NSString stringWithFormat:@"%@", message];
    printf("%s", [messageString UTF8String]);
}

@end
