//
//  IMChatMessageDisplayView+Delegate.m
//  IMChat
//
//  Created by 徐世杰 on 16/3/17.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "IMChatMessageDisplayView+Delegate.h"
#import "IMTextDisplayView.h"
#import "IMChatEventStatistics.h"

@implementation IMChatMessageDisplayView (Delegate)

#pragma mark - # Public Methods
- (void)registerCellClassForTableView:(UITableView *)tableView
{
    [tableView registerClass:[IMTextMessageCell class] forCellReuseIdentifier:@"IMTextMessageCell"];
    [tableView registerClass:[IMImageMessageCell class] forCellReuseIdentifier:@"IMImageMessageCell"];
    [tableView registerClass:[IMExpressionMessageCell class] forCellReuseIdentifier:@"IMExpressionMessageCell"];
    [tableView registerClass:[IMVoiceMessageCell class] forCellReuseIdentifier:@"IMVoiceMessageCell"];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"EmptyCell"];
}

#pragma mark - # Delegate
//MARK: UITableViewDataSouce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMMessage * message = self.data[indexPath.row];
    if (message.messageType == IMMessageTypeText) {
        IMTextMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IMTextMessageCell"];
        [cell setMessage:message];
        [cell setDelegate:self];
        return cell;
    }
    else if (message.messageType == IMMessageTypeImage) {
        IMImageMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IMImageMessageCell"];
        [cell setMessage:message];
        [cell setDelegate:self];
        return cell;
    }
    else if (message.messageType == IMMessageTypeExpression) {
        IMExpressionMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IMExpressionMessageCell"];
        [cell setMessage:message];
        [cell setDelegate:self];
        return cell;
    }
    else if (message.messageType == IMMessageTypeVoice) {
        IMVoiceMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IMVoiceMessageCell"];
        [cell setMessage:message];
        [cell setDelegate:self];
        return cell;
    }
    
    return [tableView dequeueReusableCellWithIdentifier:@"EmptyCell"];
}

//MARK: UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.row >= self.data.count) {
        return 0.0f;
    }
    IMMessage * message = self.data[indexPath.row];
    return message.messageFrame.height;
}

//MARK: IMMessageCellDelegate
- (void)messageCellDidClickAvatarForUser:(IMUser *)user
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatMessageDisplayView:didClickUserAvatar:)]) {
        [self.delegate chatMessageDisplayView:self didClickUserAvatar:user];
    }
}

- (void)messageCellTap:(IMMessage *)message
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatMessageDisplayView:didClickMessage:)]) {
        [self.delegate chatMessageDisplayView:self didClickMessage:message];
    }
}

/**
 *  双击Message Cell
 */
- (void)messageCellDoubleClick:(IMMessage *)message
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatMessageDisplayView:didDoubleClickMessage:)]) {
        [self.delegate chatMessageDisplayView:self didDoubleClickMessage:message];
    }
}

- (void)messageCellLongPress:(IMMessage *)message rect:(CGRect)rect
{
    NSInteger row = [self.data indexOfObject:message];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    if (self.disableLongPressMenu) {
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        return;
    }

    CGRect cellRect = [self.tableView rectForRowAtIndexPath:indexPath];
    rect.origin.y += cellRect.origin.y - self.tableView.contentOffset.y;
    __weak typeof(self)weakSelf = self;
    [self.menuView showInView:self withMessageType:message.messageType rect:rect actionBlock:^(IMChatMenuItemType type) {
        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        if (type == IMChatMenuItemTypeCopy) {
            NSString *str = [message messageCopy];
            [[UIPasteboard generalPasteboard] setString:str];
        }
        else if (type == IMChatMenuItemTypeDelete) {
            IMActionSheet *actionSheet = [[IMActionSheet alloc] initWithTitle:@"是否删除该条消息" delegate:weakSelf cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles: nil];
            actionSheet.tag = [weakSelf.data indexOfObject:message];
            [actionSheet show];
        }
    }];
}

//MARK: UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatMessageDisplayViewDidTouched:)]) {
        [self.delegate chatMessageDisplayViewDidTouched:self];
    }
}

//MARK: IMActionSheetDelegate
- (void)actionSheet:(IMActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        IMMessage * message = [self.data objectAtIndex:actionSheet.tag];
        [self p_deleteMessage:message];
    }
}

#pragma mark - # Private Methods
- (void)p_deleteMessage:(IMMessage *)message
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatMessageDisplayView:deleteMessage:)]) {
        BOOL ok = [self.delegate chatMessageDisplayView:self deleteMessage:message];
        if (ok) {
            [self deleteMessage:message withAnimation:YES];
        }
        else {
            [IMUIUtility showAlertWithTitle:@"错误" message:@"从数据库中删除消息失败。"];
        }
    }
}

@end
