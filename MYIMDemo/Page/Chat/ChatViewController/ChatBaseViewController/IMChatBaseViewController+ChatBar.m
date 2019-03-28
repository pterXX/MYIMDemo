//
//  IMChatBaseViewController+ChatBar.m
//  IMChat
//
//  Created by 李伯坤 on 16/3/17.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "IMChatBaseViewController+ChatBar.h"
#import "IMChatBaseViewController+Proxy.h"
#import "IMChatBaseViewController+MessageDisplayView.h"
#import "IMAudioRecorder.h"
#import "IMAudioPlayer.h"
#import "IMUserHelper.h"
#import "NSFileManager+IMChat.h"

@implementation IMChatBaseViewController (ChatBar)

#pragma mark - # Public Methods
- (void)loadKeyboard
{
    [self.emojiKeyboard setKeyboardDelegate:self];
    [self.emojiKeyboard setDelegate:self];
    [self.moreKeyboard setKeyboardDelegate:self];
    [self.moreKeyboard setDelegate:self];
}

- (void)dismissKeyboard
{
    if (curStatus == IMChatBarStatusMore) {
        [self.moreKeyboard dismissWithAnimation:YES];
        curStatus = IMChatBarStatusInit;
    }
    else if (curStatus == IMChatBarStatusEmoji) {
        [self.emojiKeyboard dismissWithAnimation:YES];
        curStatus = IMChatBarStatusInit;
    }
    [self.chatBar resignFirstResponder];
}

//MARK: 系统键盘回调
- (void)keyboardWillShow:(NSNotification *)notification
{
    if (curStatus != IMChatBarStatusKeyboard) {
        return;
    }
    [self.messageDisplayView scrollToBottomWithAnimation:YES];
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    if (curStatus != IMChatBarStatusKeyboard) {
        return;
    }
    if (lastStatus == IMChatBarStatusMore) {
        [self.moreKeyboard dismissWithAnimation:NO];
    }
    else if (lastStatus == IMChatBarStatusEmoji) {
        [self.emojiKeyboard dismissWithAnimation:NO];
    }
    [self.messageDisplayView scrollToBottomWithAnimation:YES];
    [self.chatBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(49.0f);
    }];
}

- (void)keyboardFrameWillChange:(NSNotification *)notification
{
    if (curStatus != IMChatBarStatusKeyboard && lastStatus != IMChatBarStatusKeyboard) {
        return;
    }
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (lastStatus == IMChatBarStatusMore || lastStatus == IMChatBarStatusEmoji) {
        if (keyboardFrame.size.height <= HEIGHT_CHAT_KEYBOARD) {
            return;
        }
    }
    else if (curStatus == IMChatBarStatusEmoji || curStatus == IMChatBarStatusMore) {
        return;
    }
    [self.chatBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).mas_offset(-keyboardFrame.size.height);
    }];
    [self.view layoutIfNeeded];
    [self.messageDisplayView scrollToBottomWithAnimation:YES];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    if (curStatus != IMChatBarStatusKeyboard && lastStatus != IMChatBarStatusKeyboard) {
        return;
    }
    if (curStatus == IMChatBarStatusEmoji || curStatus == IMChatBarStatusMore) {
        return;
    }
    [self.chatBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(IMTABBAR_HEIGHT);
    }];
    [self.view layoutIfNeeded];
}

#pragma mark - Delegate
//MARK: IMChatBarDelegate
// 发送文本消息
- (void)chatBar:(IMChatBar *)chatBar sendText:(NSString *)text
{
    IMTextMessage *message = [[IMTextMessage alloc] init];
    message.text = text;
    [self sendMessage:message];
}

//MARK: - 录音相关
- (void)chatBarStartRecording:(IMChatBar *)chatBar
{
    // 先停止播放
    if ([IMAudioPlayer sharedAudioPlayer].isPlaying) {
        [[IMAudioPlayer sharedAudioPlayer] stopPlayingAudio];
    }
    
    [self.recorderIndicatorView setStatus:IMRecorderStatusRecording];
    [self.messageDisplayView addSubview:self.recorderIndicatorView];
    [self.recorderIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(150, 150));
    }];
    
    __block NSInteger time_count = 0;
    IMVoiceMessage *message = [[IMVoiceMessage alloc] init];
    message.ownerTyper = IMMessageOwnerTypeSelf;
    message.userID = [IMUserHelper sharedHelper].userID;
    message.fromUser = (id<IMChatUserProtocol>)[IMUserHelper sharedHelper].user;
    message.msgStatus = IMVoiceMessageStatusRecording;
    message.date = [NSDate date];
    [[IMAudioRecorder sharedRecorder] startRecordingWithVolumeChangedBlock:^(CGFloat volume) {
        time_count ++;
        if (time_count == 2) {
            [self addToShowMessage:message];
        }
        [self.recorderIndicatorView setVolume:volume];
    } completeBlock:^(NSString *filePath, CGFloat time) {
        if (time < 1.0) {
            [self.recorderIndicatorView setStatus:IMRecorderStatusTooShort];
            return;
        }
        [self.recorderIndicatorView removeFromSuperview];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            NSString *fileName = [NSString stringWithFormat:@"%.0lf.caf", [NSDate date].timeIntervalSince1970 * 1000];
            NSString *path = [NSFileManager pathUserChatVoice:fileName];
            NSError *error;
            [[NSFileManager defaultManager] moveItemAtPath:filePath toPath:path error:&error];
            if (error) {
                DDLogError(@"录音文件出错: %@", error);
                return;
            }
            
            message.recFileName = fileName;
            message.time = time;
            message.msgStatus = IMVoiceMessageStatusNormal;
            [message resetMessageFrame];
            [self sendMessage:message];
        }
    } cancelBlock:^{
        [self.messageDisplayView deleteMessage:message];
        [self.recorderIndicatorView removeFromSuperview];
    }];
}

- (void)chatBarWillCancelRecording:(IMChatBar *)chatBar cancel:(BOOL)cancel
{
    [self.recorderIndicatorView setStatus:cancel ? IMRecorderStatusWillCancel : IMRecorderStatusRecording];
}

- (void)chatBarFinishedRecoding:(IMChatBar *)chatBar
{
    [[IMAudioRecorder sharedRecorder] stopRecording];
}

- (void)chatBarDidCancelRecording:(IMChatBar *)chatBar
{
    [[IMAudioRecorder sharedRecorder] cancelRecording];
}

//MARK: - chatBar状态切换
- (void)chatBar:(IMChatBar *)chatBar changeStatusFrom:(IMChatBarStatus)fromStatus to:(IMChatBarStatus)toStatus
{
    if (curStatus == toStatus) {
        return;
    }
    lastStatus = fromStatus;
    curStatus = toStatus;
    if (toStatus == IMChatBarStatusInit) {
        if (fromStatus == IMChatBarStatusMore) {
            [self.moreKeyboard dismissWithAnimation:YES];
        }
        else if (fromStatus == IMChatBarStatusEmoji) {
            [self.emojiKeyboard dismissWithAnimation:YES];
        }
    }
    else if (toStatus == IMChatBarStatusVoice) {
        if (fromStatus == IMChatBarStatusMore) {
            [self.moreKeyboard dismissWithAnimation:YES];
        }
        else if (fromStatus == IMChatBarStatusEmoji) {
            [self.emojiKeyboard dismissWithAnimation:YES];
        }
    }
    else if (toStatus == IMChatBarStatusEmoji) {
        [self.emojiKeyboard showInView:self.view withAnimation:YES];
    }
    else if (toStatus == IMChatBarStatusMore) {
        [self.moreKeyboard showInView:self.view withAnimation:YES];
    }
    
    if (toStatus == IMChatBarStatusMore
        || toStatus == IMChatBarStatusEmoji) {
        [self.chatBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(49);
        }];
    }else{
        [self.chatBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(IMTABBAR_HEIGHT);
        }];
    }
}

- (void)chatBar:(IMChatBar *)chatBar didChangeTextViewHeight:(CGFloat)height
{
    [self.messageDisplayView scrollToBottomWithAnimation:NO];
}

//MARK: IMKeyboardDelegate
- (void)chatKeyboardWillShow:(id)keyboard animated:(BOOL)animated
{
    [self.messageDisplayView scrollToBottomWithAnimation:YES];
}

- (void)chatKeyboardDidShow:(id)keyboard animated:(BOOL)animated
{
    if (curStatus == IMChatBarStatusMore && lastStatus == IMChatBarStatusEmoji) {
        [self.emojiKeyboard dismissWithAnimation:NO];
    }
    else if (curStatus == IMChatBarStatusEmoji && lastStatus == IMChatBarStatusMore) {
        [self.moreKeyboard dismissWithAnimation:NO];
    }
    [self.messageDisplayView scrollToBottomWithAnimation:YES];
}

- (void)chatKeyboard:(id)keyboard didChangeHeight:(CGFloat)height
{
    [self.chatBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).mas_offset(-height);
    }];
    [self.view layoutIfNeeded];
    [self.messageDisplayView scrollToBottomWithAnimation:YES];
}

//MARK: IMEmojiKeyboardDelegate
- (void)emojiKeyboard:(IMEmojiKeyboard *)emojiKB didSelectedEmojiItem:(IMExpressionModel *)emoji
{
    if (emoji.type == IMEmojiTypeEmoji || emoji.type == IMEmojiTypeFace) {
        [self.chatBar addEmojiString:emoji.name];
    }
    else {
        IMExpressionMessage *message = [[IMExpressionMessage alloc] init];
        message.emoji = emoji;
        [self sendMessage:message];
    }
}

- (void)emojiKeyboardSendButtonDown
{
    [self.chatBar sendCurrentText];
}

- (void)emojiKeyboardDeleteButtonDown
{
    [self.chatBar deleteLastCharacter];
}

- (void)emojiKeyboard:(IMEmojiKeyboard *)emojiKB didTouchEmojiItem:(IMExpressionModel *)emoji atRect:(CGRect)rect
{
    if (emoji.type == IMEmojiTypeEmoji || emoji.type == IMEmojiTypeFace) {
        if (self.emojiDisplayView.superview == nil) {
            [self.emojiKeyboard addSubview:self.emojiDisplayView];
        }
        [self.emojiDisplayView displayEmoji:emoji atRect:rect];
    }
    else {
        if (self.imageExpressionDisplayView.superview == nil) {
            [self.emojiKeyboard addSubview:self.imageExpressionDisplayView];
        }
        [self.imageExpressionDisplayView displayEmoji:emoji atRect:rect];
    }
}

- (void)emojiKeyboardCancelTouchEmojiItem:(IMEmojiKeyboard *)emojiKB
{
    if (self.emojiDisplayView.superview != nil) {
        [self.emojiDisplayView removeFromSuperview];
    }
    else if (self.imageExpressionDisplayView.superview != nil) {
        [self.imageExpressionDisplayView removeFromSuperview];
    }
}

- (void)emojiKeyboard:(IMEmojiKeyboard *)emojiKB selectedEmojiGroupType:(IMEmojiType)type
{
    if (type == IMEmojiTypeEmoji || type == IMEmojiTypeFace) {
        [self.chatBar setActivity:YES];
    }
    else {
        [self.chatBar setActivity:NO];
    }
}

- (BOOL)chatInputViewHasText
{
    return self.chatBar.curText.length == 0 ? NO : YES;
}

#pragma mark - # Getter
- (IMEmojiKeyboard *)emojiKeyboard
{
    return [IMEmojiKeyboard keyboard];
}

- (IMMoreKeyboard *)moreKeyboard
{
    return [IMMoreKeyboard keyboard];
}


@end
