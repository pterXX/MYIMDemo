//
//  IMEmojiKeyboard+EmojiGroupControl.m
//  IMChat
//
//  Created by 李伯坤 on 16/3/17.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "IMEmojiKeyboard+EmojiGroupControl.h"
#import "IMExpressionGroupModel+IMEmojiKB.h"

@implementation IMEmojiKeyboard (EmojiGroupControl)

#pragma mark - Delegate
//MARK: IMEmojiGroupControlDelegate
- (void)emojiGroupControl:(IMEmojiGroupControl *)emojiGroupControl didSelectedGroup:(IMExpressionGroupModel *)group
{
    // 显示Group表情
    self.curGroup = group;
    [self.displayView scrollToEmojiGroupAtIndex:[self.emojiGroupData indexOfObject:group]];
    [self.pageControl setNumberOfPages:group.pageNumber];
    [self.pageControl setCurrentPage:0];
    // 更新chatBar的textView状态
    if (self.delegate && [self.delegate respondsToSelector:@selector(emojiKeyboard:selectedEmojiGroupType:)]) {
        [self.delegate emojiKeyboard:self selectedEmojiGroupType:group.type];
    }
}

- (void)emojiGroupControlEditMyEmojiButtonDown:(IMEmojiGroupControl *)emojiGroupControl
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(emojiKeyboardMyEmojiEditButtonDown)]) {
        [self.delegate emojiKeyboardMyEmojiEditButtonDown];
    }
}

- (void)emojiGroupControlEditButtonDown:(IMEmojiGroupControl *)emojiGroupControl
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(emojiKeyboardEmojiEditButtonDown)]) {
        [self.delegate emojiKeyboardEmojiEditButtonDown];
    }
}

- (void)emojiGroupControlSendButtonDown:(IMEmojiGroupControl *)emojiGroupControl
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(emojiKeyboardSendButtonDown)]) {
        [self.delegate emojiKeyboardSendButtonDown];
    }
}

@end
