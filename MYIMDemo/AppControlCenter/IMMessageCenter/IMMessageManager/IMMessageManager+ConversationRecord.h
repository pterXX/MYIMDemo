//
//  IMMessageManager+ConversationRecord.h
//  IMChat
//
//  Created by 徐世杰 on 16/3/20.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "IMMessageManager.h"

@interface IMMessageManager (ConversationRecord)

- (BOOL)addConversationByMessage:(IMMessage *)message;

- (void)conversationRecord:(void (^)(NSArray *))complete;

- (BOOL)deleteConversationByPartnerID:(NSString *)partnerID;

@end
