//
//  IntermediateCodeImp.m
//  Mak
//
//  Created by Alex Restrepo on 6/29/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "IntermediateCodeImp.h"

@interface IntermediateCodeImp ()

@property (nonatomic, strong) id<IntermediateCodeNode> root;

@end

@implementation IntermediateCodeImp

- (id<IntermediateCodeNode>)rootNode {
    return _root;
}

- (id<IntermediateCodeNode>)setRootNode:(id<IntermediateCodeNode>)rootNode {
    self.root = rootNode;
    return _root;
}

@end
