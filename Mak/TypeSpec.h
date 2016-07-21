//
//  TypeSpec.h
//  Mak
//
//  Created by Alex Restrepo on 7/19/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SymbolTableEntry.h"

@protocol TypeForm <NSObject>
@end

@protocol TypeKey <NSObject, NSCopying>
@end

@protocol TypeSpec <NSObject>

- (id<TypeForm>)form;
- (void)setIdentifier:(id<SymbolTableEntry>)identifier;
- (id<SymbolTableEntry>)identifier;
- (void)setAttribute:(id)value forKey:(id<TypeKey>)key;
- (id)attributeForKey:(id<TypeKey>)key;
- (BOOL)isPascalString;
- (id<TypeSpec>)baseType;

@end
