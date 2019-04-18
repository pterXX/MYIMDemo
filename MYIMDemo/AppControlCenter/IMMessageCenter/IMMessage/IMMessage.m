//
//  IMMessage.m
//  IMChat
//
//  Created by 徐世杰 on 16/2/15.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "IMMessage.h"

@implementation IMMessage

+ (IMMessage *)createMessageByType:(IMMessageType)type
{
    NSString *className;
    if (type == IMMessageTypeText) {
        className = @"IMTextMessage";
    }
    else if (type == IMMessageTypeImage) {
        className = @"IMImageMessage";
    }
    else if (type == IMMessageTypeExpression) {
        className = @"IMExpressionMessage";
    }
    else if (type == IMMessageTypeVoice) {
        className = @"IMVoiceMessage";
    }
    if (className) {
        return [[NSClassFromString(className) alloc] init];
    }
    return nil;
}

- (id)init
{
    if (self = [super init]) {
        self.messageID = [NSString stringWithFormat:@"%lld", (long long)([[NSDate date] timeIntervalSince1970] * 10000)];
    }
    return self;
}

- (void)resetMessageFrame
{
    kMessageFrame = nil;
}


#pragma mark - # Protocol
- (NSString *)conversationContent
{
    return @"子类未定义";
}

- (NSString *)messageCopy
{
    return @"子类未定义";
}


#pragma mark - # Getter
- (NSMutableDictionary *)content
{
    if (_content == nil) {
        _content = [[NSMutableDictionary alloc] init];
    }
    return _content;
}

@end
