//
//  IntermediateCode.h
//  Mak
//
//  Created by Alex Restrepo on 5/16/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TypeSpec.h"

@protocol IntermediateCodeKey <NSObject, NSCopying>

@end

@protocol IntermediateCodeNodeType <NSObject>

@end

@protocol IntermediateCodeNode <NSObject, NSCopying>

@property (nonatomic, strong) id<IntermediateCodeNodeType> type;
@property (nonatomic, weak) id<IntermediateCodeNode> parentNode;

- (id<IntermediateCodeNode>)addChild:(id<IntermediateCodeNode>)child;
- (NSArray<id<IntermediateCodeNode>> *)children;
- (NSDictionary<id<IntermediateCodeKey>, id> *)attributes;
- (void)setAttribute:(id)value forKey:(id<IntermediateCodeKey>)key;
- (id)attributeForKey:(id<IntermediateCodeKey>)key;
- (void)setTypeSpec:(id<TypeSpec>)typeSpec;
- (id<TypeSpec>)typeSpec;

@end

@protocol IntermediateCode <NSObject>

- (id<IntermediateCodeNode>)rootNode;
- (id<IntermediateCodeNode>)setRootNode:(id<IntermediateCodeNode>)rootNode;

@end
