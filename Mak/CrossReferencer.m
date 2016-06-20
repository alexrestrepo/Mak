//
//  CrossReferencer.m
//  Mak
//
//  Created by Alex Restrepo on 6/19/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "CrossReferencer.h"

#import "SymbolTableStack.h"

@implementation CrossReferencer

- (void)printSymbolTableStack:(id<SymbolTableStack>)symbolTableStack {
    printf("\n===== CROSS-REFERENCE TABLE =====\n");
    [self printColumnHeadings];
    [self printSymbolTable:[symbolTableStack localSymbolTable]];
}

- (void)printColumnHeadings {
    NSString *identifier = [[@"Identifier" stringByPaddingToLength:16 withString:@" " startingAtIndex:0]
                            stringByAppendingString:@"Line Numbers"];
    
    printf("\n%s",[identifier UTF8String]);
    printf("\n----------      ------------\n");
}

- (void)printSymbolTable:(id<SymbolTable>)symbolTable {
    NSArray <id<SymbolTableEntry>> *entries = [symbolTable sortedEntries];
    [entries enumerateObjectsUsingBlock:^(id<SymbolTableEntry>  _Nonnull entry, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *lineNumbers = [entry lineNumbers];
        NSString *name = [[entry name] stringByPaddingToLength:16 withString:@" " startingAtIndex:0];
        printf("%s", [name UTF8String]);
        
        if (lineNumbers) {
            [lineNumbers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                printf("%03ld ", (long)[obj integerValue]);
            }];
        }
        printf("\n");
    }];
}

@end
