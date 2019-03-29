//
//  IMChatViewController+Conversation.h
//  IMChat
//
//  Created by 徐世杰 on 2017/12/26.
//  Copyright © 2017年 徐世杰. All rights reserved.
//

#import "IMChatViewController.h"
#import "IMConversation.h"

@interface IMChatViewController (Conversation)

- (instancetype)initWithConversation:(IMConversation *)conversation;

@end
