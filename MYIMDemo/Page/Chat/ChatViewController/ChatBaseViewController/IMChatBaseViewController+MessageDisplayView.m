//
//  IMChatBaseViewController+MessageDisplayView.m
//  IMChat
//
//  Created by 李伯坤 on 16/3/17.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "IMChatBaseViewController+MessageDisplayView.h"
#import "IMChatBaseViewController+ChatBar.h"
#import "IMTextDisplayView.h"

@implementation IMChatBaseViewController (MessageDisplayView)

#pragma mark - # Public Methods
- (void)addToShowMessage:(IMMessage *)message
{
    message.showTime = [self p_needShowTime:message.date];
    [self.messageDisplayView addMessage:message];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.messageDisplayView scrollToBottomWithAnimation:YES];
    });
}

- (void)addVoiceRecordingMessage:(IMMessage *)message
{
    message.date = [NSDate date];
}

- (void)resetChatTVC
{
    [self.messageDisplayView resetMessageView];
    lastDateInterval = 0;
    msgAccumulate = 0;
}

#pragma mark - # Delegate
//MARK: IMChatMessageDisplayViewDelegate
// chatView 点击事件
- (void)chatMessageDisplayViewDidTouched:(IMChatMessageDisplayView *)chatTVC
{
    [self dismissKeyboard];
}

// chatView 获取历史记录
- (void)chatMessageDisplayView:(IMChatMessageDisplayView *)chatTVC getRecordsFromDate:(NSDate *)date count:(NSUInteger)count completed:(void (^)(NSDate *, NSArray *, BOOL))completed
{
    kWeakSelf(self);
    [[IMMessageManager sharedInstance] messageRecordForPartner:[self.partner chat_userID] fromDate:date count:count complete:^(NSArray *array, BOOL hasMore) {
        if (array.count > 0) {
            int count = 0;
            NSTimeInterval tm = 0;
            for (IMMessage *message in array) {
                if (++count > MAX_SHOWTIME_MSG_COUNT || tm == 0 || message.date.timeIntervalSince1970 - tm > MAX_SHOWTIME_MSG_SECOND) {
                    tm = message.date.timeIntervalSince1970;
                    count = 0;
                    message.showTime = YES;
                }
                if (message.ownerTyper == IMMessageOwnerTypeSelf) {
                    message.fromUser = weakSelf.user;
                }
                else {
                    if ([weakSelf.partner chat_userType] == IMChatUserTypeUser) {
                        message.fromUser = weakSelf.partner;
                    }
                    else if ([weakSelf.partner chat_userType] == IMChatUserTypeGroup){
                        if ([weakSelf.partner respondsToSelector:@selector(groupMemberByID:)]) {
                            message.fromUser = [weakSelf.partner groupMemberByID:message.friendID];
                        }
                    }
                }
            }
        }
        completed(date, array, hasMore);
    }];
}

- (BOOL)chatMessageDisplayView:(IMChatMessageDisplayView *)chatTVC deleteMessage:(IMMessage *)message
{
    return [[IMMessageManager sharedInstance] deleteMessageByMsgID:message.messageID];
}

- (void)chatMessageDisplayView:(IMChatMessageDisplayView *)chatTVC didClickUserAvatar:(IMUser *)user
{
    if ([self respondsToSelector:@selector(didClickedUserAvatar:)]) {
        [self didClickedUserAvatar:user];
    }
}

- (void)chatMessageDisplayView:(IMChatMessageDisplayView *)chatTVC didDoubleClickMessage:(IMMessage *)message
{
    if (message.messageType == IMMessageTypeText) {
        IMTextDisplayView *displayView = [[IMTextDisplayView alloc] init];
        [displayView showInView:self.navigationController.view withAttrText:[(IMTextMessage *)message attrText] animation:YES];
    }
}

- (void)chatMessageDisplayView:(IMChatMessageDisplayView *)chatTVC didClickMessage:(IMMessage *)message
{
    if (message.messageType == IMMessageTypeImage && [self respondsToSelector:@selector(didClickedImageMessages:atIndex:)]) {
        // 展示聊天图片
        [[IMMessageManager sharedInstance] chatImagesAndVideosForPartnerID:[self.partner chat_userID] completed:^(NSArray *imagesData) {
            NSInteger index = -1;
            for (int i = 0; i < imagesData.count; i ++) {
                if ([message.messageID isEqualToString:[imagesData[i] messageID]]) {
                    index = i;
                    break;
                }
            }
            if (index >= 0) {
                [self didClickedImageMessages:imagesData atIndex:index];
            }
        }];
    }
    else if (message.messageType == IMMessageTypeVoice) {
        if ([(IMVoiceMessage *)message msgStatus] == IMVoiceMessageStatusNormal) {
            // 播放语音消息
            [(IMVoiceMessage *)message setMsgStatus:IMVoiceMessageStatusPlaying];
            
            [[IMAudioPlayer sharedAudioPlayer] playAudioAtPath:[(IMVoiceMessage *)message path] complete:^(BOOL finished) {
                [(IMVoiceMessage *)message setMsgStatus:IMVoiceMessageStatusNormal];
                [self.messageDisplayView updateMessage:message];
            }];
        }
        else {
            // 停止播放语音消息
            [[IMAudioPlayer sharedAudioPlayer] stopPlayingAudio];
        }
    }
}

#pragma mark - # Private Methods
static NSTimeInterval lastDateInterval = 0;
static NSInteger msgAccumulate = 0;
- (BOOL)p_needShowTime:(NSDate *)date
{
    if (++msgAccumulate > MAX_SHOWTIME_MSG_COUNT || lastDateInterval == 0 || date.timeIntervalSince1970 - lastDateInterval > MAX_SHOWTIME_MSG_SECOND) {
        lastDateInterval = date.timeIntervalSince1970;
        msgAccumulate = 0;
        return YES;
    }
    return NO;
}


@end
