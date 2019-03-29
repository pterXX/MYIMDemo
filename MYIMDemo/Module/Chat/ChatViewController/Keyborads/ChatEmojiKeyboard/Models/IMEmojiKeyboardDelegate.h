//
//  IMEmojiKeyboardDelegate.h
//  IMChat
//
//  Created by 徐世杰 on 16/2/20.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMExpressionModel.h"

@class IMEmojiKeyboard;
@protocol IMEmojiKeyboardDelegate <NSObject>

- (BOOL)chatInputViewHasText;

@optional
/**
 *  长按某个表情（展示）
 */
- (void)emojiKeyboard:(IMEmojiKeyboard *)emojiKB didTouchEmojiItem:(IMExpressionModel *)emoji atRect:(CGRect)rect;

/**
 *  取消长按某个表情（停止展示）
 */
- (void)emojiKeyboardCancelTouchEmojiItem:(IMEmojiKeyboard *)emojiKB;

/**
 *  点击事件 —— 选中某个表情
 */
- (void)emojiKeyboard:(IMEmojiKeyboard *)emojiKB didSelectedEmojiItem:(IMExpressionModel *)emoji;

/**
 *  点击事件 —— 表情发送按钮
 */
- (void)emojiKeyboardSendButtonDown;

/**
 *  点击事件 —— 删除按钮
 */
- (void)emojiKeyboardDeleteButtonDown;

/**
 *  点击事件 —— 表情编辑按钮
 */
- (void)emojiKeyboardEmojiEditButtonDown;

/**
 *  点击事件 —— 我的表情按钮
 */
- (void)emojiKeyboardMyEmojiEditButtonDown;

/**
 *  选中不同类型的表情组回调
 *  用于改变chatBar状态（个性表情组展示时textView不可用）
 */
- (void)emojiKeyboard:(IMEmojiKeyboard *)emojiKB selectedEmojiGroupType:(IMEmojiType)type;

@end
