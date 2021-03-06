//
//  IMExpressionMessage.m
//  IMChat
//
//  Created by libokun on 16/3/28.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "IMExpressionMessage.h"

@implementation IMExpressionMessage
@synthesize emoji = _emoji;

- (id)init
{
    if (self = [super init]) {
        [self setMessageType:IMMessageTypeExpression];
    }
    return self;
}

- (void)setEmoji:(IMExpressionModel *)emoji
{
    _emoji = emoji;
    [self.content setObject:emoji.gid forKey:@"groupID"];
    [self.content setObject:emoji.eId forKey:@"emojiID"];
    CGSize imageSize = [UIImage imageNamed:self.path].size;
    [self.content setObject:[NSNumber numberWithDouble:imageSize.width] forKey:@"w"];
    [self.content setObject:[NSNumber numberWithDouble:imageSize.height] forKey:@"h"];
}
- (IMExpressionModel *)emoji
{
    if (_emoji == nil) {
        _emoji = [[IMExpressionModel alloc] init];
        _emoji.gid = self.content[@"groupID"];
        _emoji.eId = self.content[@"emojiID"];
    }
    return _emoji;
}

- (NSString *)path
{
    return self.emoji.path;
}

- (NSString *)url
{
    return [IMExpressionModel expressionDownloadURLWithEid:self.emoji.eId];
}

- (CGSize)emojiSize
{
    CGFloat width = [self.content[@"w"] doubleValue];
    CGFloat height = [self.content[@"h"] doubleValue];
    return CGSizeMake(width, height);
}

#pragma mark -
- (IMMessageFrame *)messageFrame
{
    if (kMessageFrame == nil) {
        kMessageFrame = [[IMMessageFrame alloc] init];
        kMessageFrame.height = 20 + (self.showTime ? 30 : 0) + (self.showName ? 15 : 0);
        
        kMessageFrame.height += 5;
        
        CGSize emojiSize = self.emojiSize;
        if (CGSizeEqualToSize(emojiSize, CGSizeZero)) {
            kMessageFrame.contentSize = CGSizeMake(80, 80);
        }
        else if (emojiSize.width > emojiSize.height) {
            CGFloat height = MAX_MESSAGE_EXPRESSION_WIDTH * emojiSize.height / emojiSize.width;
            height = height < MIN_MESSAGE_EXPRESSION_WIDTH ? MIN_MESSAGE_EXPRESSION_WIDTH : height;
            kMessageFrame.contentSize = CGSizeMake(MAX_MESSAGE_EXPRESSION_WIDTH, height);
        }
        else {
            CGFloat width = MAX_MESSAGE_EXPRESSION_WIDTH * emojiSize.width / emojiSize.height;
            width = width < MIN_MESSAGE_EXPRESSION_WIDTH ? MIN_MESSAGE_EXPRESSION_WIDTH : width;
            kMessageFrame.contentSize = CGSizeMake(width, MAX_MESSAGE_EXPRESSION_WIDTH);
        }
    
        kMessageFrame.height += kMessageFrame.contentSize.height;
    }
    return kMessageFrame;
}

- (NSString *)conversationContent
{
    return @"[表情]";
}

- (NSString *)messageCopy
{
    return [self.content mj_JSONString];
}

@end
