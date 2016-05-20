//
//  Message.h
//  Mak
//
//  Created by Alex Restrepo on 5/13/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "Token.h"
#import "Notifications.h"

typedef enum : NSUInteger {
    MessageTypeSourceLine,
    MessageTypeSyntaxError,
    MessageTypeParserSummary,
    MessageTypeInterpreterSummary,
    MessageTypeCompilerSummary,
    MessageTypeToken,
    MessageTypeAssign,
    MessageTypeFetch,
    MessageTypeBreakpoint,
    MessageTypeRuntimeError,
    MessageTypeCall,
    MessageTypeReturn,
    MessageTypeMisc,
} MessageType;

@interface Message : NSObject

@property (nonatomic, assign, readonly) MessageType type;
@property (nonatomic, assign, readonly) NSArray *body;

+ (NSString *)stringForMessageType:(MessageType)type;
+ (instancetype)messageWithType:(MessageType)type body:(NSArray *)body;
- (instancetype)initWithMessageType:(MessageType)type body:(NSArray *)body;

@end
