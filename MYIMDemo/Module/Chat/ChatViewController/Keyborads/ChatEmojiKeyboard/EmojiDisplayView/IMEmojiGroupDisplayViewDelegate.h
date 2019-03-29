//
//  IMEmojiGroupDisplayViewDelegate.h
//  IMChat
//
//  Created by 徐世杰 on 16/9/27.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IMExpressionModel;
@class IMEmojiGroupDisplayView;
@protocol IMEmojiGroupDisplayViewDelegate <NSObject>

/**
 *  发送按钮点击事件
 */
- (void)emojiGroupDisplayViewDeleteButtonPressed:(IMEmojiGroupDisplayView *)displayView;

/**
 *  选中表情
 */
- (void)emojiGroupDisplayView:(IMEmojiGroupDisplayView *)displayView didClickedEmoji:(IMExpressionModel *)emoji;

/**
 *  翻页
 */
- (void)emojiGroupDisplayView:(IMEmojiGroupDisplayView *)displayView didScrollToPageIndex:(NSInteger)pageIndex forGroupIndex:(NSInteger)groupIndex;

/**
 *  表情长按
 */
- (void)emojiGroupDisplayView:(IMEmojiGroupDisplayView *)displayView didLongPressEmoji:(IMExpressionModel *)emoji atRect:(CGRect)rect;

/**
 *  停止表情长按
 */
- (void)emojiGroupDisplayViewDidStopLongPressEmoji:(IMEmojiGroupDisplayView *)displayView;

@end
