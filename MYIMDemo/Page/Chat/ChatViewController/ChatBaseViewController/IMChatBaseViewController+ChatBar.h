//
//  IMChatBaseViewController+ChatBar.h
//  IMChat
//
//  Created by 李伯坤 on 16/3/17.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "IMChatBaseViewController.h"
#import "IMMoreKeyboard.h"
#import "IMEmojiKeyboard.h"

@interface IMChatBaseViewController (ChatBar) <IMChatBarDelegate, IMKeyboardDelegate, IMEmojiKeyboardDelegate>

/// 表情键盘
@property (nonatomic, strong, readonly) IMEmojiKeyboard *emojiKeyboard;

/// 更多键盘
@property (nonatomic, strong, readonly) IMMoreKeyboard *moreKeyboard;

- (void)loadKeyboard;
- (void)dismissKeyboard;

- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardDidShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;
- (void)keyboardFrameWillChange:(NSNotification *)notification;


@end
