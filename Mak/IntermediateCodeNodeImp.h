//
//  IntermediateCodeNodeImp.h
//  Mak
//
//  Created by Alex Restrepo on 6/29/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IntermediateCode.h"

@interface IntermediateCodeNodeImp : NSObject <IntermediateCodeNode>

- (instancetype)initWithType:(id<IntermediateCodeNodeType>)type;

@end
