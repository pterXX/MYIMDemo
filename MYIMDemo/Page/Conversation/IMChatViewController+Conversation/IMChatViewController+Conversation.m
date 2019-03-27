//
//  IMChatViewController+Conversation.m
//  IMChat
//
//  Created by 李伯坤 on 2017/12/26.
//  Copyright © 2017年 李伯坤. All rights reserved.
//

#import "IMChatViewController+Conversation.h"

@implementation IMChatViewController (Conversation)

- (instancetype)initWithConversation:(IMConversation *)conversation
{
    if (conversation.convType == IMConversationTypePersonal) {
        return [self initWithUserId:conversation.partnerID];
    }
    else if (conversation.convType == IMConversationTypeGroup){
        return [self initWithGroupId:conversation.partnerID];
    }
    return [super init];
}

@end
