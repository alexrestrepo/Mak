//
//  Message.m
//  Mak
//
//  Created by Alex Restrepo on 5/13/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import "Message.h"

@implementation Message

+ (NSString *)stringForMessageType:(MessageType)type {
    NSArray *messages = @[@"MessageTypeSourceLine",
                          @"MessageTypeSyntaxError",
                          @"MessageTypeParserSummary",
                          @"MessageTypeInterpreterSummary",
                          @"MessageTypeCompilerSummary",
                          @"MessageTypeToken",
                          @"MessageTypeAssign",
                          @"MessageTypeFetch",
                          @"MessageTypeBreakpoint",
                          @"MessageTypeRuntimeError",
                          @"MessageTypeCall",
                          @"MessageTypeReturn",
                          @"MessageTypeMisc"];
    
    return messages[type];
}

+ (instancetype)messageWithType:(MessageType)type body:(NSArray *)body {
    return [[Message alloc] initWithMessageType:type body:body];
}

- (instancetype)initWithMessageType:(MessageType)type body:(NSArray *)body
{
    self = [super init];
    if (self) {
        _type = type;
        _body = body;
    }
    return self;
}

- (NSString *)description {
    NSString *descriptionString = @"";
    switch (_type) {
        case MessageTypeSourceLine:
            descriptionString = [NSString stringWithFormat:@"%03ld %@\n", (long)[_body[0] integerValue], _body[1]];
            break;
        case MessageTypeSyntaxError:
        {
            NSString *msg = [@"-" stringByPaddingToLength:4 + [_body[1] integerValue]
                                               withString:@"-"
                                          startingAtIndex:0];
            descriptionString = [msg stringByAppendingFormat:@"^\n*** %@ at[\"%@\"]\n", _body[3], _body[2]];
        }
            break;
        case MessageTypeParserSummary:
            descriptionString = [NSString stringWithFormat:@"\n%20ld source lines.\n%20ld syntax errors.\n%20.2f seconds total parsing time.\n",
                                 (long)[_body[0] integerValue], (long)[_body[1] integerValue], [_body[2] doubleValue]];
            break;
        case MessageTypeInterpreterSummary:
            descriptionString = [NSString stringWithFormat:@"\n%20ld statements executed.\n%20ld runtime errors.\n%20.2f seconds total execution time.\n",
                                 (long)[_body[0] integerValue], (long)[_body[1] integerValue], [_body[2] doubleValue]];
            break;
        case MessageTypeCompilerSummary:
            descriptionString = [NSString stringWithFormat:@"\n%20ld instructions generated.\n%20.2f seconds total code generation time.\n",
                                 (long)[_body[0] integerValue], [_body[1] doubleValue]];
            break;
        case MessageTypeToken:
        {
            NSString *type = [_body[2] description];
            type = [type stringByPaddingToLength:15 withString:@" " startingAtIndex:0];
            descriptionString = [NSString stringWithFormat:@">>> %@ line=%03ld, pos=%2ld, text=\"%@\" value=%@\n",
                                 type, (long)[_body[0] integerValue], (long)[_body[1] integerValue], _body[3], _body[4]];
        }
            break;
        case MessageTypeAssign:
            
            break;
        case MessageTypeFetch:
            break;
        case MessageTypeBreakpoint:
            break;
        case MessageTypeRuntimeError:
            break;
        case MessageTypeCall:
            break;
        case MessageTypeReturn:
            break;
        case MessageTypeMisc:
            break;
    }
    
    return descriptionString;
}

@end
