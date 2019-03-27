//
//  IMChatBaseViewController.h
//  IMChat
//
//  Created by 李伯坤 on 16/2/15.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMChatViewControllerProxy.h"
#import "IMChatMessageDisplayView.h"
#import "IMEmojiDisplayView.h"
#import "IMImageExpressionDisplayView.h"
#import "IMRecorderIndicatorView.h"

#import "IMMoreKeyboardDelegate.h"
#import "IMMessageManager+MessageRecord.h"

#import "IMChatBar.h"
#import "IMMoreKeyboardDelegate.h"

#import "IMChatUserProtocol.h"
#import "IMUser.h"

@interface IMChatBaseViewController : UIViewController <IMChatViewControllerProxy, IMMoreKeyboardDelegate>
{
    IMChatBarStatus lastStatus;
    IMChatBarStatus curStatus;
}

/// 用户信息
@property (nonatomic, strong) id<IMChatUserProtocol> user;

/// 聊天对象
@property (nonatomic, strong) id<IMChatUserProtocol> partner;

/// 消息展示页面
@property (nonatomic, strong) IMChatMessageDisplayView *messageDisplayView;

/// 聊天输入栏
@property (nonatomic, strong) IMChatBar *chatBar;

/// emoji展示view
@property (nonatomic, strong) IMEmojiDisplayView *emojiDisplayView;

/// 图片表情展示view
@property (nonatomic, strong) IMImageExpressionDisplayView *imageExpressionDisplayView;

/// 录音展示view
@property (nonatomic, strong) IMRecorderIndicatorView *recorderIndicatorView;;

/**
 *  设置“更多”键盘元素
 */
- (void)setChatMoreKeyboardData:(NSMutableArray *)moreKeyboardData;

/**
 *  设置“表情”键盘元素
 */
- (void)setChatEmojiKeyboardData:(NSMutableArray *)emojiKeyboardData;

/**
 *  重置chatVC
 */
- (void)resetChatVC;

/**
 *  发送图片信息
 */
- (void)sendImageMessage:(UIImage *)image;

@end
