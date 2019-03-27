//
//  IMEmojiKeyboard+DisplayView.m
//  IMChat
//
//  Created by 李伯坤 on 16/9/27.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "IMEmojiKeyboard+DisplayView.h"
#import "IMExpressionGroupModel+IMEmojiKB.h"

@implementation IMEmojiKeyboard (DisplayView)

#pragma mark - # Delegate
//MARK: IMEmojiGroupDisplayViewDelegate
- (void)emojiGroupDisplayView:(IMEmojiGroupDisplayView *)displayView didClickedEmoji:(IMExpressionModel *)emoji
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(emojiKeyboard:didSelectedEmojiItem:)]) {
        [self.delegate emojiKeyboard:self didSelectedEmojiItem:emoji];
    }
}

- (void)emojiGroupDisplayViewDeleteButtonPressed:(IMEmojiGroupDisplayView *)displayView;
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(emojiKeyboardDeleteButtonDown)]) {
        [self.delegate emojiKeyboardDeleteButtonDown];
    }
}

- (void)emojiGroupDisplayView:(IMEmojiGroupDisplayView *)displayView didScrollToPageIndex:(NSInteger)pageIndex forGroupIndex:(NSInteger)groupIndex
{
    IMExpressionGroupModel *group = self.emojiGroupData[groupIndex];
    if (self.curGroup != group) {
        self.curGroup = group;
        [self.pageControl setHidden:group.pageNumber <= 1];
        [self.pageControl setNumberOfPages:group.pageNumber];
        [self.groupControl selectEmojiGroupAtIndex:groupIndex];
        if (self.delegate && [self.delegate respondsToSelector:@selector(emojiKeyboard:selectedEmojiGroupType:)]) {
            [self.delegate emojiKeyboard:self selectedEmojiGroupType:group.type];
        }
    }
    [self.pageControl setCurrentPage:pageIndex];

}

static UICollectionViewCell *lastCell;
- (void)emojiGroupDisplayView:(IMEmojiGroupDisplayView *)displayView didLongPressEmoji:(IMExpressionModel *)emoji atRect:(CGRect)rect
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(emojiKeyboard:didTouchEmojiItem:atRect:)]) {
        [self.delegate emojiKeyboard:self didTouchEmojiItem:emoji atRect:rect];
    }
}

- (void)emojiGroupDisplayViewDidStopLongPressEmoji:(IMEmojiGroupDisplayView *)displayView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(emojiKeyboardCancelTouchEmojiItem:)]) {
        [self.delegate emojiKeyboardCancelTouchEmojiItem:self];
    }
}


@end
