//
//  IMChatBaseViewController+Proxy.m
//  IMChat
//
//  Created by 徐世杰 on 16/3/17.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "IMChatBaseViewController+Proxy.h"
#import "IMChatBaseViewController+MessageDisplayView.h"
#import "IMUserHelper.h"

@implementation IMChatBaseViewController (Proxy)

- (void)sendMessage:(IMMessage *)message
{
    message.ownerTyper = IMMessageOwnerTypeSelf;
    message.userID = [IMUserHelper sharedHelper].userID;
    message.fromUser = (id<IMChatUserProtocol>)[IMUserHelper sharedHelper].user;
    message.date = [NSDate date];
    
    if ([self.partner chat_userType] == IMChatUserTypeUser) {
        message.partnerType = IMPartnerTypeUser;
        message.friendID = [self.partner chat_userID];
    }
    else if ([self.partner chat_userType] == IMChatUserTypeGroup) {
        message.partnerType = IMPartnerTypeGroup;
        message.groupID = [self.partner chat_userID];
    }
    
    if (message.messageType != IMMessageTypeVoice) {
        [self addToShowMessage:message];    // 添加到列表
    }
    else {
        [self.messageDisplayView updateMessage:message];
    }
    
    [[IMMessageManager sharedInstance] sendMessage:message progress:^(IMMessage * message, CGFloat pregress) {
        
    } success:^(IMMessage * message) {
        NSLog(@"send success");
    } failure:^(IMMessage * message) {
        NSLog(@"send failure");
    }];
}

- (void)didReceivedMessage:(IMMessage *)message;
{
    if ([message.userID isEqualToString:self.user.chat_userID]) {
        [self addToShowMessage:message];    // 添加到列表
    }
}

@end
