//
//  IMTextMessage.m
//  IMChat
//
//  Created by libokun on 16/3/28.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "IMTextMessage.h"
#import "NSString+Message.h"

static UILabel *texIMabel = nil;

@implementation IMTextMessage
@synthesize text = _text;

- (id)init
{
    if (self = [super init]) {
        [self setMessageType:IMMessageTypeText];
        if (texIMabel == nil) {
            texIMabel = [[UILabel alloc] init];
            [texIMabel setFont:[UIFont fontTextMessageText]];
            [texIMabel setNumberOfLines:0];
        }
    }
    return self;
}

- (NSString *)text
{
    if (_text == nil) {
        _text = [self.content objectForKey:@"text"];
    }
    return _text;
}
- (void)setText:(NSString *)text
{
    _text = text;
    [self.content setObject:text forKey:@"text"];
}

- (NSAttributedString *)attrText
{
    if (_attrText == nil) {
        _attrText = [self.text toMessageString];
    }
    return _attrText;
}

- (IMMessageFrame *)messageFrame
{
    if (kMessageFrame == nil) {
        kMessageFrame = [[IMMessageFrame alloc] init];
        kMessageFrame.height = 20 + (self.showTime ? 30 : 0) + (self.showName ? 15 : 0) + 20;
        [texIMabel setAttributedText:self.attrText];
        kMessageFrame.contentSize = [texIMabel sizeThatFits:CGSizeMake(MAX_MESSAGE_WIDTH, MAXFLOAT)];
        kMessageFrame.height += kMessageFrame.contentSize.height;
    }
    return kMessageFrame;
}

- (NSString *)conversationContent
{
    return self.text;
}

- (NSString *)messageCopy
{
    return self.text;
}

@end
