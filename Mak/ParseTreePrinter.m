//
//  ParseTreePrinter.m
//  Mak
//
//  Created by Alex Restrepo on 6/29/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "ParseTreePrinter.h"
#import "SymbolTable.h"
#import "SymTabKey.h"

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
    NSString *typeString = @"";
    id<TypeSpec> typeSpec = [node typeSpec];

    if (typeSpec) {
        NSString *saveMarging = [_indentation copy];
        self.indentation = [self.indentation stringByAppendingString:_indent];

        NSString *typeName;
        id<SymbolTableEntry> identifier = [typeSpec identifier];
        if (identifier) {
            typeName = [identifier name];

        } else {
            NSInteger code = [typeSpec hash] + [[typeSpec form] hash];
            typeName = [NSString stringWithFormat:@"$anon_%lx", (long)code];
        }

        typeString = [self stringFromAttributeWithStringKey:@"TYPE_ID" object:typeName];
        self.indentation = saveMarging;
    }


    return typeString;
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

- (NSString *)stringFromSymbolTableStack:(id<SymbolTableStack>)stack {
    id<SymbolTableEntry> programID = [stack programIdEntry];
    NSString *root = [self stringFromRoutine:programID];
    return [NSString stringWithFormat:@"\n===== INTERMEDIATE CODE =====\n%@\n", root];
}

- (NSString *)stringFromRoutine:(id<SymbolTableEntry>)routineID {
    id<Definition> definition = [routineID definition];
    NSMutableString *result = [NSMutableString new];

    [result appendFormat:@"\n*** %@ %@ ***\n", definition, [routineID name]];
    id<IntermediateCode> icode = [routineID attributeForKey:[SymTabKey ROUTINE_ICODE]];
    if ([icode rootNode]) {
        [result appendString:[self stringFromNode:[icode rootNode]]];
    }

    NSArray <id<SymbolTableEntry>> *routineIDs = [routineID attributeForKey:[SymTabKey ROUTINE_ROUTINES]];
    if (routineIDs) {
        for (id<SymbolTableEntry> routineID in routineIDs) {
            [result appendString:[self stringFromRoutine:routineID]];
        }
    }
    return result;
}

@end
