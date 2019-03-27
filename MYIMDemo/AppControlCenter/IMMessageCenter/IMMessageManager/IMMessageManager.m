//
//  IMMessageManager.m
//  IMChat
//
//  Created by 李伯坤 on 16/3/13.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "IMMessageManager.h"
#import "IMMessageManager+ConversationRecord.h"
#import "IMUserHelper.h"
#import "IMNetwork.h"

#import "IMFriendHelper.h"
#import "IMTextMessage.h"
#import "IMImageMessage.h"

static IMMessageManager *messageManager;

@implementation IMMessageManager

+ (IMMessageManager *)sharedInstance
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        messageManager = [[IMMessageManager alloc] init];
    });
    return messageManager;
}

- (void)sendMessage:(IMMessage *)message
           progress:(void (^)(IMMessage *, CGFloat))progress
            success:(void (^)(IMMessage *))success
            failure:(void (^)(IMMessage *))failure
{
    // 图灵机器人
    [self p_sendMessageToReboot:message];
    
    BOOL ok = [self.messageStore addMessage:message];
    if (!ok) {
        DDLogError(@"存储Message到DB失败");
    }
    else {      // 存储到conversation
        ok = [self addConversationByMessage:message];
        if (!ok) {
            DDLogError(@"存储Conversation到DB失败");
        }
    }
}

#pragma mark - # Private
- (void)p_sendMessageToReboot:(IMMessage *)message
{
    if (message.messageType == IMMessageTypeText) {
        // 聊天的用户
        IMUser *user;
        if (message.partnerType == IMPartnerTypeGroup) {
            IMGroup *group = [[IMFriendHelper sharedFriendHelper] getGroupInfoByGroupID:message.groupID];
            NSInteger index = arc4random() % group.count;
            user = group.users[index];
        }
        else {
            user = [[IMFriendHelper sharedFriendHelper] getFriendInfoByUserID:message.friendID];
        }
        
        NSString *text = [message.content objectForKey:@"text"];
        NSString *apiKey = ({
            NSString *key;
            if ([user.userID isEqualToString:@"1001"]) {   // 曾小贤
                key = @"00916307c7b24533a23d6115224540f3";
            }
            else if ([user.userID isEqualToString:@"1002"]) {   // 陈美嘉
                key = @"5f5f8d7d613f4d81a6ff354cb428ccbc";
            }
            else {
                key = @"44eb0b4ab0a640f192bd469551a7c03e";
            }
            key;
        });
        NSDictionary *json = @{@"reqType" : @"0",
                               @"userInfo" : @{
                                       @"apiKey" : apiKey,
                                       @"userId" : @"100454",
                                       },
                               @"perception" : @{
                                       @"inputText" : @{
                                               @"text" : text,
                                               }
                                       },
                               };
        NSString *url = @"http://openapi.tuling123.com/openapi/api/v2";
        IMBaseRequest *request = [IMBaseRequest requestWithMethod:IMRequestMethodPOST url:url parameters:json];
        [request startRequestWithSuccessAction:^(IMResponse *response) {
            NSDictionary *json = response.responseObject;
            NSArray *results = [json objectForKey:@"results"];
            for (NSDictionary *item in results) {
                NSDictionary *values = [item objectForKey:@"values"];
                if (values[@"text"]) {
                    NSString *text = values[@"text"];
                    IMTextMessage *textMessage = [[IMTextMessage alloc] init];
                    textMessage.partnerType = message.partnerType;
                    textMessage.text = text;
                    textMessage.ownerTyper = IMMessageOwnerTypeFriend;
                    textMessage.userID = message.userID;
                    textMessage.date = [NSDate date];
                    textMessage.friendID = user.userID;
                    textMessage.fromUser = (id <IMChatUserProtocol>)user;
                    textMessage.groupID = message.groupID;
                    [self.messageStore addMessage:textMessage];
                    if (self.messageDelegate && [self.messageDelegate respondsToSelector:@selector(didReceivedMessage:)]) {
                        [self.messageDelegate didReceivedMessage:textMessage];
                    }
                }
                else if (values[@"image"]) {
                    NSString *imageURL = values[@"image"];
                    IMImageMessage *imageMessage = [[IMImageMessage alloc] init];
                    imageMessage.partnerType = message.partnerType;
                    imageMessage.imageURL = imageURL;
                    imageMessage.ownerTyper = IMMessageOwnerTypeFriend;
                    imageMessage.userID = message.userID;
                    imageMessage.friendID = user.userID;
                    imageMessage.date = [NSDate date];
                    imageMessage.fromUser = (id <IMChatUserProtocol>)user;
                    imageMessage.imageSize = CGSizeMake(120, 120);
                    imageMessage.groupID = message.groupID;
                    [self.messageStore addMessage:imageMessage];
                    if (self.messageDelegate && [self.messageDelegate respondsToSelector:@selector(didReceivedMessage:)]) {
                        [self.messageDelegate didReceivedMessage:imageMessage];
                    }
                }
            }
        } failureAction:nil];
    }
}

#pragma mark - # Getters
- (IMDBMessageStore *)messageStore
{
    if (_messageStore == nil) {
        _messageStore = [[IMDBMessageStore alloc] init];
    }
    return _messageStore;
}

- (IMDBConversationStore *)conversationStore
{
    if (_conversationStore == nil) {
        _conversationStore = [[IMDBConversationStore alloc] init];
    }
    return _conversationStore;
}

- (NSString *)userID
{
    return [IMUserHelper sharedHelper].userID;
}

@end
