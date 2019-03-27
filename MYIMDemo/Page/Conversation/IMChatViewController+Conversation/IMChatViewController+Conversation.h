//
//  IMChatViewController+Conversation.h
//  IMChat
//
//  Created by 李伯坤 on 2017/12/26.
//  Copyright © 2017年 李伯坤. All rights reserved.
//

#import "IMChatViewController.h"
#import "IMConversation.h"

@interface IMChatViewController (Conversation)

- (instancetype)initWithConversation:(IMConversation *)conversation;

@end
