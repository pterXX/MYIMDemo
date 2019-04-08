//
//  IMChatBarDelegate.h
//  IMChat
//
//  Created by 徐世杰 on 16/3/1.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMChatMacros.h"

@class IMChatBar;
@protocol IMChatBarDelegate <NSObject>

/**
 *  chatBar状态改变
 */
- (void)chatBar:(IMChatBar *)chatBar changeStatusFrom:(IMChatBarStatus)fromStatus to:(IMChatBarStatus)toStatus;

/**
 *  输入框高度改变
 */
- (void)chatBar:(IMChatBar *)chatBar didChangeTextViewHeight:(CGFloat)height;

/**
 *  发送文字
 */
- (void)chatBar:(IMChatBar *)chatBar sendText:(NSString *)text;


// 录音控制 
- (void)chatBarStartRecording:(IMChatBar *)chatBar;

- (void)chatBarWillCancelRecording:(IMChatBar *)chatBar cancel:(BOOL)cancel;

- (void)chatBarDidCancelRecording:(IMChatBar *)chatBar;

- (void)chatBarFinishedRecoding:(IMChatBar *)chatBar;

@end
