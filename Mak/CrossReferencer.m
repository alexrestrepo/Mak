//
//  CrossReferencer.m
//  Mak
//
//  Created by Alex Restrepo on 6/19/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "CrossReferencer.h"

#import "SymbolTableStack.h"
#import "SymTabKey.h"
#import "DefinitionImpl.h"
#import "TypeSpec.h"
#import "TypeFormImpl.h"
#import "TypeKeyImpl.h"

@implementation CrossReferencer

- (void)printSymbolTableStack:(id<SymbolTableStack>)symbolTableStack {
    printf("\n===== CROSS-REFERENCE TABLE =====\n");

    id<SymbolTableEntry> programID = [symbolTableStack programIdEntry];
    [self printRoutine:programID];
}

- (void)printRoutine:(id<SymbolTableEntry>)routineID {
    id<Definition> definition = [routineID definition];

    printf("\n*** %s %s ***\n", [[definition description] UTF8String], [[routineID name] UTF8String]);
    [self printColumnHeadings];

    // print entries in the routines symtab
    id<SymbolTable> symTab = [routineID attributeForKey:[SymTabKey ROUTINE_SYMTAB]];
    NSMutableArray<id<TypeSpec>> *newRecordTypes = [NSMutableArray new];
    [self printSymbolTable:symTab types:newRecordTypes];

    if (newRecordTypes.count) {
        [self printRecords:newRecordTypes];
    }

    NSArray <id<SymbolTableEntry>> *routineIDs = [routineID attributeForKey:[SymTabKey ROUTINE_ROUTINES]];
    if (routineID) {
        for (id<SymbolTableEntry> routineID in routineIDs) {
            [self printRoutine:routineID];
        }
    }
}

- (void)printColumnHeadings {
    printf("\n");
    printf("%s Line numbers    Type Specification\n", [[@"Identifier" stringByPaddingToLength:16 withString:@" " startingAtIndex:0] UTF8String]);
    printf("%s ------------    ------------------\n", [[@"----------" stringByPaddingToLength:16 withString:@" " startingAtIndex:0] UTF8String]);
}

- (void)printSymbolTable:(id<SymbolTable>)symbolTable types:(NSMutableArray<id<TypeSpec>> *)types {
    NSArray <id<SymbolTableEntry>> *entries = [symbolTable sortedEntries];
    [entries enumerateObjectsUsingBlock:^(id<SymbolTableEntry>  _Nonnull entry, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *lineNumbers = [entry lineNumbers];
        NSString *name = [[entry name] stringByPaddingToLength:16 withString:@" " startingAtIndex:0];
        printf("%s ", [name UTF8String]);
        
        if (lineNumbers) {
            [lineNumbers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                printf("%03ld ", (long)[obj integerValue]);
            }];
        }
        printf("\n");
        [self printEntry:entry types:types];
    }];
}

- (NSString *)stringValue:(id)value {
    if ([value isKindOfClass:[NSString class]]) {
        return [NSString stringWithFormat:@"'%@'", value];
    }

    return [value stringValue];
}

- (void)printEntry:(id<SymbolTableEntry>)entry types:(NSMutableArray<id<TypeSpec>> *)types {
    id<Definition> definition = [entry definition];
    NSInteger nestingLevel = [[entry symbolTable] nestingLevel];
    printf("                                 Defined as: %s\n", [[definition description] UTF8String]);
    printf("                                 Scope nesting level: %s\n", [[@(nestingLevel) stringValue] UTF8String]);

    id<TypeSpec> type = [entry typeSpec];
    [self printType:type];

    if (definition == [DefinitionImpl CONSTANT]) {
        id value = [entry attributeForKey:[SymTabKey CONSTANT_VALUE]];
        printf("                                 Value = %s\n", [[self stringValue:value] UTF8String]);

        if ([type identifier]) {
            [self printTypeDetail:type types:types];
        }

    } else if (definition == [DefinitionImpl ENUMERATION_CONSTANT]) {
        id value = [entry attributeForKey:[SymTabKey CONSTANT_VALUE]];
        printf("                                 Value = %s\n", [[self stringValue:value] UTF8String]);


    } else if (definition == [DefinitionImpl TYPE]) {
        if (entry == [type identifier]) {
            [self printTypeDetail:type types:types];
        }

    } else if (definition == [DefinitionImpl VARIABLE]) {
        if (![type identifier]) {
            [self printTypeDetail:type types:types];
        }
    }
    printf("\n");
}

- (void)printType:(id<TypeSpec>)type {
    if (type) {
        id<TypeForm> form = [type form];
        id<SymbolTableEntry> typeID = [type identifier];
        NSString *typeName = typeID ? [typeID name] : @"<unnamed>";
        printf("                                 Type form = %s, Type id = %s\n", [[form description] UTF8String], [typeName UTF8String]);
    }
}

- (void)printTypeDetail:(id<TypeSpec>)type types:(NSMutableArray<id<TypeSpec>> *)types {
    id<TypeForm> form = [type form];
    if (form == [TypeFormImpl ENUMERATION]) {
        NSArray <id<SymbolTableEntry>> *constantIDs = [type attributeForKey:[TypeKeyImpl ENUMERATION_CONSTANTS]];
        printf("                                 --- Enumeration Constants ---\n");

        for (id<SymbolTableEntry> constantID in constantIDs) {
            NSString *name = [constantID name];
            id value = [constantID attributeForKey:[SymTabKey CONSTANT_VALUE]];
            printf("                                 %s = %s\n", [[name stringByPaddingToLength:16 withString:@" " startingAtIndex:0] UTF8String], [[value description] UTF8String]);
        }

    } else if (form == [TypeFormImpl SUBRANGE]) {
        id minValue = [type attributeForKey:[TypeKeyImpl SUBRANGE_MIN_VALUE]];
        id maxValue = [type attributeForKey:[TypeKeyImpl SUBRANGE_MAX_VALUE]];
        id<TypeSpec> baseTypeSpec = [type attributeForKey:[TypeKeyImpl SUBRANGE_BASE_TYPE]];

        printf("                                 --- Base Type ---\n");
        [self printType:baseTypeSpec];

        if (![baseTypeSpec identifier]) {
            [self printTypeDetail:baseTypeSpec types:types];
        }

        printf("                                 Range = ");
        printf("%s..%s\n", [[self stringValue:minValue] UTF8String], [[self stringValue:maxValue] UTF8String]);

    } else if (form == [TypeFormImpl ARRAY]) {
        id<TypeSpec> indexType = [type attributeForKey:[TypeKeyImpl ARRAY_INDEX_TYPE]];
        id<TypeSpec> elementType = [type attributeForKey:[TypeKeyImpl ARRAY_ELEMENT_TYPE]];
        NSInteger count = [[type attributeForKey:[TypeKeyImpl ARRAY_ELEMENT_COUNT]] integerValue];

        printf("                                 --- Index Type ---\n");
        [self printType:indexType];

        if (![indexType identifier]) {
            [self printTypeDetail:indexType types:types];
        }

        printf("                                 --- Element Type ---\n");
        [self printType:elementType];

        printf("                                 %ld elements\n", (long)count);

        if (![elementType identifier]) {
            [self printTypeDetail:elementType types:types];
        }

    } else if (form == [TypeFormImpl RECORD]) {
        [types addObject:type];
    }
}

- (void)printRecords:(NSArray<id<TypeSpec>> *)records {
    for (id<TypeSpec> recordType in records) {
        id<SymbolTableEntry> recordID = [recordType identifier];
        NSString *name = recordID ? [recordID name] : @"<unnamed>";

        printf("\n--- RECORD %s ---\n", [name UTF8String]);
        [self printColumnHeadings];

        id<SymbolTable> symTab = [recordType attributeForKey:[TypeKeyImpl RECORD_SYMTAB]];
        NSMutableArray <id<TypeSpec>> *newRecordTypes = [NSMutableArray new];
        [self printSymbolTable:symTab types:newRecordTypes];

        if ([newRecordTypes count]) {
            [self printRecords:newRecordTypes];
        }
    }
}

@end
