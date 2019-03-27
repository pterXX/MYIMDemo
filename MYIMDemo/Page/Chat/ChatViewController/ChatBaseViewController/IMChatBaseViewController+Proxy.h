//
//  IMChatBaseViewController+Proxy.h
//  IMChat
//
//  Created by 李伯坤 on 16/3/17.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "IMChatBaseViewController.h"

@interface IMChatBaseViewController (Proxy) <IMMessageManagerChatVCDelegate>

/**
 *  发送消息
 */
- (void)sendMessage:(IMMessage *)message;

@end
