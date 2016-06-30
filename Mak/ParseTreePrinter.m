//
//  ParseTreePrinter.m
//  Mak
//
//  Created by Alex Restrepo on 6/29/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "ParseTreePrinter.h"
#import "SymbolTable.h"

@interface ParseTreePrinter ()

@property (nonatomic, copy) NSString *indent;
@property (nonatomic, copy) NSString *indentation;

@end

static const NSInteger IndentWidth = 4;

@implementation ParseTreePrinter

- (instancetype)init {
    self = [super init];
    if (self) {
        _indent = [@"" stringByPaddingToLength:IndentWidth withString:@" " startingAtIndex:0];
        _indentation = @"";
    }
    return self;
}

- (NSString *)stringFromIntermediateCode:(id<IntermediateCode>)code {
    NSString *root = [self stringFromNode:code.rootNode];
    return [NSString stringWithFormat:@"\n===== INTERMEDIATE CODE =====\n%@\n", root];
}

- (NSString *)stringFromNode:(id<IntermediateCodeNode>)node {
    NSMutableString *buffer = [NSMutableString new];
    
    [buffer appendString:_indentation];
    [buffer appendFormat:@"<%@", node];
    [buffer appendString:[self stringFromNodeAttributes:node]];
    [buffer appendString:[self stringFromNodeTypeSpec:node]];
    
    NSArray <id<IntermediateCodeNode>> *children = [node children];
    if ([children count]) {
        [buffer appendString:@">\n"];
        [buffer appendString:[self stringFromChildNodes:children]];
        [buffer appendString:_indentation];
        [buffer appendFormat:@"</%@>", node];
        
    } else {
        [buffer appendFormat:@"/>"];
    }
    
    [buffer appendString:@"\n"];
    return buffer;
}

- (NSString *)stringFromNodeAttributes:(id<IntermediateCodeNode>)node {
    NSMutableString *buffer = [NSMutableString new];
    NSString *saveIndentation = [_indentation copy];
    self.indentation = [self.indentation stringByAppendingString:_indent];
    [[node attributes] enumerateKeysAndObjectsUsingBlock:^(id<IntermediateCodeKey>  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [buffer appendString:[self stringFromAttributeWithStringKey:[key description] object:obj]];
    }];
    self.indentation = saveIndentation;
    return buffer;
}

- (NSString *)stringFromNodeTypeSpec:(id<IntermediateCodeNode>)node {
    return @"";
}

- (NSString *)stringFromChildNodes:(NSArray <id<IntermediateCodeNode>> *)children {
    NSMutableString *buffer = [NSMutableString new];
    NSString *saveIndentation = [_indentation copy];
    self.indentation = [self.indentation stringByAppendingString:_indent];
    
    [children enumerateObjectsUsingBlock:^(id<IntermediateCodeNode>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [buffer appendString:[self stringFromNode:obj]];
    }];
    
    self.indentation = saveIndentation;
    return buffer;
}

- (NSString *)stringFromAttributeWithStringKey:(NSString *)key object:(id)object {
    const BOOL isSymbolTableEntry = [object conformsToProtocol:@protocol(SymbolTableEntry)];
    
    NSString *valueString = isSymbolTableEntry ? [((id<SymbolTableEntry>) object) name] : [object description];
    NSString *text = [[key lowercaseString] stringByAppendingFormat:@"=\"%@\"", valueString];
    NSString *result = [@" " stringByAppendingString:text];
    
    if (isSymbolTableEntry) {
        NSInteger level = [[((id<SymbolTableEntry>) object) symbolTable] nestingLevel];
        result = [result stringByAppendingString:[self stringFromAttributeWithStringKey:@"LEVEL" object:@(level)]];
    }
    
    return result;
}

@end
