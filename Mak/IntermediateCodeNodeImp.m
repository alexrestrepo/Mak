//
//  IntermediateCodeNodeImp.m
//  Mak
//
//  Created by Alex Restrepo on 6/29/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "IntermediateCodeNodeImp.h"

#import "IntermediateCodeFactory.h"

@interface IntermediateCodeNodeImp ()

@property (nonatomic, strong) NSMutableDictionary<id<IntermediateCodeKey>, id> *attributes;
@property (nonatomic, strong) NSMutableArray<id<IntermediateCodeNode>> *children;
@property (nonatomic, strong) id<TypeSpec> typeSpec;

@end

@implementation IntermediateCodeNodeImp

@synthesize type = _type;
@synthesize parentNode = _parentNode;

- (instancetype)initWithType:(id<IntermediateCodeNodeType>)type {
    self = [super init];
    if (self) {
        _type = type;
        _parentNode = nil;
        _children = [NSMutableArray new];
        _attributes = [NSMutableDictionary new];
    }
    return self;
}

- (id<IntermediateCodeNode>)addChild:(id<IntermediateCodeNode>)child {
    if (child) {
        [_children addObject:child];
        child.parentNode = self;
    }
    return nil;
}

- (NSArray<id<IntermediateCodeNode>> *)children {
    return _children;
}

- (NSDictionary<id<IntermediateCodeKey>, id> *)attributes {
    return [_attributes copy];
}

- (void)setAttribute:(id)value forKey:(id<IntermediateCodeKey>)key {
    _attributes[key] = value;
}

- (id)attributeForKey:(id<IntermediateCodeKey>)key {
    return _attributes[key];
}

- (id)copyWithZone:(NSZone *)zone {
    id<IntermediateCodeNode> copy = [IntermediateCodeFactory intermediateCodeNodeWithType:self.type];
    
    [_attributes enumerateKeysAndObjectsUsingBlock:^(id<IntermediateCodeKey>  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [copy setAttribute:obj forKey:key];
    }];
    
    return copy;
}

- (NSString *)description {
    return [_type description];
}

@end
