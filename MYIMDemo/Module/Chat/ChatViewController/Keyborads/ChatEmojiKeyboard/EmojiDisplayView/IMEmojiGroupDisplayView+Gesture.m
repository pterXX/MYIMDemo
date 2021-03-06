//
//  IMEmojiGroupDisplayView+Gesture.m
//  IMChat
//
//  Created by 徐世杰 on 16/9/28.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "IMEmojiGroupDisplayView+Gesture.h"
#import "IMEmojiGroupDisplayView+CollectionView.h"
#import "IMEmojiBaseCell.h"

@implementation IMEmojiGroupDisplayView (Gesture)

#pragma mark - # Public Methods
- (void)addGusture
{
    UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [self.collectionView addGestureRecognizer:longPressGR];
}

#pragma mark - # Event Response
static UICollectionViewCell *lastCell;
- (void)longPressAction:(UILongPressGestureRecognizer *)sender
{
    IMEmojiGroupDisplayModel *curGroup = [self.displayData objectAtIndex:self.curPageIndex];
    CGPoint point = [sender locationInView:self.collectionView];
    if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateCancelled) {        // 长按停止
        [self p_cancelLongPressEmoji];
        lastCell = nil;
    }
    else if (sender.state == UIGestureRecognizerStateBegan) {
        NSArray *visableCells = self.collectionView.visibleCells;
        for (IMEmojiBaseCell *cell in visableCells) {
            if (cell.x <= point.x && cell.y <= point.y && cell.x + curGroup.cellSize.width >= point.x && cell.y + curGroup.cellSize.height >= point.y) {
                NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
                NSInteger index = [self transformModelByRowCount:curGroup.rowNumber colCount:curGroup.colNumber andIndex:indexPath.row];  // 矩阵坐标转置
                IMExpressionModel *emoji = [curGroup objectAtIndex:index];
                if (emoji) {
                    if ((emoji.type == IMEmojiTypeEmoji || emoji.type == IMEmojiTypeFace) && [emoji.eId isEqualToString:@"-1"]) {        // 删除
                        
                    }
                    else {
                        CGRect rect = [cell displayBaseRect];
                        rect.origin.x = rect.origin.x - self.width * (int)(rect.origin.x / self.width);
                        [self p_startLongPressEmoji:emoji atRect:rect];
                    }
                }
                return;
            }
        }
        lastCell = nil;
    }
    else {
        NSArray *visableCells = self.collectionView.visibleCells;
        for (IMEmojiBaseCell *cell in visableCells) {
            if (cell.x <= point.x && cell.y <= point.y && cell.x + curGroup.cellSize.width >= point.x && cell.y + curGroup.cellSize.height >= point.y) {
                if (cell == lastCell) {
                    return;
                }
                NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
                NSInteger index = [self transformModelByRowCount:curGroup.rowNumber colCount:curGroup.colNumber andIndex:indexPath.row];  // 矩阵坐标转置
                IMExpressionModel *emoji = [curGroup objectAtIndex:index];
                if (emoji) {
                    if ((emoji.type == IMEmojiTypeEmoji || emoji.type == IMEmojiTypeFace) && [emoji.eId isEqualToString:@"-1"]) {        // 删除
                        [self p_cancelLongPressEmoji];
                    }
                    else {
                        CGRect rect = [cell displayBaseRect];
                        rect.origin.x = rect.origin.x - self.width * (int)(rect.origin.x / self.width);
                        [self p_startLongPressEmoji:emoji atRect:rect];
                    }
                }
                else {         // 空白cell
                    [self p_cancelLongPressEmoji];
                }
                lastCell = cell;
                return;
            }
        }
        
        // 超出界限
        if (lastCell) {
            [self p_cancelLongPressEmoji];
            lastCell = nil;
        }
    }
}

#pragma mark - # Private Methods
static IMExpressionModel *lastEmoji;
- (void)p_startLongPressEmoji:(IMExpressionModel *)emoji atRect:(CGRect)rect
{
    if (emoji != lastEmoji) {
        lastEmoji = emoji;
        IMEmojiGroupDisplayModel *curGroup = [self.displayData objectAtIndex:self.curPageIndex];
        emoji.type = curGroup.type;
        if (self.delegate && [self.delegate respondsToSelector:@selector(emojiGroupDisplayView:didLongPressEmoji:atRect:)]) {
            [self.delegate emojiGroupDisplayView:self didLongPressEmoji:emoji atRect:rect];
        }
    }
}

- (void)p_cancelLongPressEmoji
{
    if (lastEmoji) {
        lastEmoji = nil;
        if (self.delegate && [self.delegate respondsToSelector:@selector(emojiGroupDisplayViewDidStopLongPressEmoji:)]) {       // 停止长按表情
            [self.delegate emojiGroupDisplayViewDidStopLongPressEmoji:self];
        }
    }
}


@end
