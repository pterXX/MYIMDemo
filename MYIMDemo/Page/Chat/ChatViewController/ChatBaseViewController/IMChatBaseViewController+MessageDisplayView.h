//
//  IMChatBaseViewController+MessageDisplayView.h
//  IMChat
//
//  Created by 李伯坤 on 16/3/17.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "IMChatBaseViewController.h"
#import "IMAudioPlayer.h"

#define     MAX_SHOWTIME_MSG_COUNT      10
#define     MAX_SHOWTIME_MSG_SECOND     30

@interface IMChatBaseViewController (MessageDisplayView) <IMChatMessageDisplayViewDelegate>

/**
 *  添加展示消息（添加到chatVC）
 */
- (void)addToShowMessage:(IMMessage *)message;

- (void)resetChatTVC;

@end
