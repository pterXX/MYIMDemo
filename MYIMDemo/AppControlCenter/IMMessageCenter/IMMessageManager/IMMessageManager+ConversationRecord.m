//
//  IMMessageManager+ConversationRecord.m
//  IMChat
//
//  Created by 李伯坤 on 16/3/20.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "IMMessageManager+ConversationRecord.h"
#import "IMMessageManager+MessageRecord.h"

@implementation IMMessageManager (ConversationRecord)

- (BOOL)addConversationByMessage:(IMMessage *)message
{
    NSString *partnerID = message.friendID;
    NSInteger type = 0;
    if (message.partnerType == IMPartnerTypeGroup) {
        partnerID = message.groupID;
        type = 1;
    }
    BOOL ok = [self.conversationStore addConversationByUid:message.userID fid:partnerID type:type date:message.date];
    
    return ok;
}

- (void)conversationRecord:(void (^)(NSArray *))complete
{
    NSArray *data = [self.conversationStore conversationsByUid:self.userID];
    complete(data);
}

- (BOOL)deleteConversationByPartnerID:(NSString *)partnerID
{
    BOOL ok = [self deleteMessagesByPartnerID:partnerID];
    if (ok) {
        ok = [self.conversationStore deleteConversationByUid:self.userID fid:partnerID];
    }
    return ok;
}

@end
