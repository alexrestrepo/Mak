//
//  TypeSpecImpl.m
//  Mak
//
//  Created by Alex Restrepo on 7/19/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "TypeSpecImpl.h"

#import "TypeFormImpl.h"
#import "TypeSpecImpl.h"
#import "TypeKeyImpl.h"
#import "Predefined.h"

@interface TypeSpecImpl()

@property (nonatomic, strong) NSMutableDictionary <id<TypeKey>, id> *attributes;
@property (nonatomic, strong) id<TypeForm> form;
@property (nonatomic, weak) id<SymbolTableEntry> identifier;

@end

@implementation TypeSpecImpl

- (instancetype)initWithForm:(id<TypeForm>)form {
    self = [super init];
    if (self) {
        _attributes = [NSMutableDictionary new];
        _form = form;        
    }
    return self;
}

- (instancetype)initWithString:(NSString *)value {
    self = [self initWithForm:[TypeFormImpl ARRAY]];
    if (self) {
        id<TypeSpec> indexType = [[TypeSpecImpl alloc] initWithForm:[TypeFormImpl SUBRANGE]];
        [indexType setAttribute:[Predefined integerType] forKey:[TypeKeyImpl SUBRANGE_BASE_TYPE]];
        [indexType setAttribute:@1 forKey:[TypeKeyImpl SUBRANGE_MIN_VALUE]];
        [indexType setAttribute:@([value length]) forKey:[TypeKeyImpl SUBRANGE_MAX_VALUE]];
        
        [self setAttribute:indexType forKey:[TypeKeyImpl ARRAY_INDEX_TYPE]];
        [self setAttribute:[Predefined charType] forKey:[TypeKeyImpl ARRAY_ELEMENT_TYPE]];
        [self setAttribute:@([value length]) forKey:[TypeKeyImpl ARRAY_ELEMENT_COUNT]];
    }
    return self;
}

- (void)setAttribute:(id)value forKey:(id<TypeKey>)key {
    value = value ? value : [NSNull null];
    [_attributes setObject:value forKey:key];
}

- (id)attributeForKey:(id<TypeKey>)key {
    return _attributes[key];
}

- (BOOL)isPascalString {
    if (_form == [TypeFormImpl ARRAY]) {
        id<TypeSpec> elementType = [self attributeForKey:[TypeKeyImpl ARRAY_ELEMENT_TYPE]];
        id<TypeSpec> indexType = [self attributeForKey:[TypeKeyImpl ARRAY_INDEX_TYPE]];
        
        return ([elementType baseType] == [Predefined charType]
                && [indexType baseType] == [Predefined integerType]);
    }
    return NO;
}

- (id<TypeSpec>)baseType {
    return _form == [TypeFormImpl SUBRANGE] ? [self attributeForKey:[TypeKeyImpl SUBRANGE_BASE_TYPE]] : self;
}

@end
