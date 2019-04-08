//
//  IMMessageManager.m
//  IMChat
//
//  Created by 徐世杰 on 16/3/13.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "IMMessageManager.h"
#import "IMMessageManager+ConversationRecord.h"
#import "IMUserHelper.h"
#import "IMNetwork.h"

#import "IMFriendHelper.h"
#import "IMTextMessage.h"
#import "IMImageMessage.h"


#define kMessageType @"messageType"
#define kPartnerType @"partnerType"
#define kContent @"content"
#define kText @"text"
#define kUserID @"userID"
#define kFriendID @"friendID"
#define kGroupID @"groupID"
#define kPath @"path"
#define kUrl @"url"
#define kWidth @"w"
#define kHeight @"h"

static IMMessageManager *messageManager;
@interface IMMessageManager()<IMXMPPHelperMessageProtocol>

@end

@implementation IMMessageManager

+ (IMMessageManager *)sharedInstance
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        messageManager = [[IMMessageManager alloc] init];
        KIMXMPPHelper.messageDelegate = messageManager;
    });
    return messageManager;
}

- (void)sendMessage:(IMMessage *)message
           progress:(void (^)(IMMessage *, CGFloat))progress
            success:(void (^)(IMMessage *))success
            failure:(void (^)(IMMessage *))failure
{
    [self p_sendMessage:message];
    // 图灵机器人
//    [self p_sendMessageToReboot:message];
    
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
- (void)p_sendMessage:(IMMessage *)message{
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
    
    //  获取值
    NSMutableDictionary *dict = [message mj_keyValuesWithKeys:@[@"messageID",kUserID,kFriendID,kGroupID,@"date",kMessageType,kPartnerType,@"readState",kContent]].mutableCopy;
    if ([dict[@"date"] isKindOfClass:[NSDate class]]) {
        NSInteger time = [((NSDate *)dict[@"date"] ) timeIntervalSince1970];
        dict[@"date"] = [@(time) stringValue];
    }
    //  区分聊天类型
     dict[kText] = [self p_messageTypeText:message.messageType]?:dict[kContent][kText];
    // 发送消息
     [KIMXMPPHelper sendMessage:dict to:user.userJid];
}

- (NSString *)p_messageTypeText:(IMMessageType)messageType{
    switch (messageType) {
        case IMMessageTypeUnknown:
            return @"[未知消息]";
        case IMMessageTypeText:
            return nil;
        case IMMessageTypeImage:
            return @"[图片]";
        case IMMessageTypeExpression:
            return @"[表情]";
        case IMMessageTypeVoice:
            return @"[语音]";
        case IMMessageTypeVideo:
            return @"[视频]";
        case IMMessageTypeURL:
            return @"[链接]";
        case IMMessageTypePosition:
            return @"[位置]";
        case IMMessageTypeBusinessCard:
            return @"[名片]";
        case IMMessageTypeSystem:
            return @"[系统消息]";
        default:
            return @"[其他消息]";
    }
}

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

#define Messgae(key) [message elementForName:key]
#define MessageString(key) [Messgae(key) stringValue]
#define MessageInt(key) [Messgae(key) stringValueAsInt]

#define IMMessage_Funtion(name,ModelName)\
 ModelName *name = [[ModelName alloc] init];\
 name.partnerType = MessageInt(kPartnerType); \
 name.ownerTyper = IMMessageOwnerTypeFriend;\
 name.userID = MessageString(kUserID);\
 name.friendID = user.userID;\
 name.date = [NSDate date];\
 name.groupID = MessageString(kGroupID); \
 name.fromUser = (id <IMChatUserProtocol>)user;\

#pragma mark - # IMXMPPHelperMessageProtocol
- (void)xmppHelper:(IMXMPPHelper *)xmppHelper sendSuccessMessage:(XMPPMessage *)message{
    NSLog(@"sendSuccessMessage ===> %@",message);
}

- (void)xmppHelper:(IMXMPPHelper *)xmppHelper receiveMessage:(XMPPMessage *)message{
    NSLog(@"receiveMessage ===> %@",message);
    NSInteger messageType = MessageInt(kMessageType);
    
    IMPartnerType partnerType = MessageInt(kPartnerType);
    // 聊天的用户
    IMUser *user;
    if (partnerType == IMPartnerTypeGroup) {
        IMGroup *group = [[IMFriendHelper sharedFriendHelper] getGroupInfoByGroupID:MessageString(kGroupID)];
        NSInteger index = arc4random() % group.count;
        user = group.users[index];
    }
    else {
        user = [[IMFriendHelper sharedFriendHelper] getFriendInfoByUserID:MessageString(kFriendID)];
    }
    IMMessage *immessage = nil;
    if (messageType == IMMessageTypeText) {
        IMMessage_Funtion(textMessage, IMTextMessage);
        textMessage.text = [[Messgae(kContent) elementForName:kText] stringValue];
        immessage = textMessage;
    }else if(messageType == IMMessageTypeImage){
        IMMessage_Funtion(imageMessage, IMImageMessage);
        CGFloat w = [[Messgae(kContent) elementForName:kWidth] stringValueAsFloat];
        CGFloat h = [[Messgae(kContent) elementForName:kHeight] stringValueAsFloat];
        imageMessage.imageURL = [[Messgae(kContent) elementForName:kUrl] stringValue];
        imageMessage.imagePath = [[Messgae(kContent) elementForName:kPath] stringValue];
        imageMessage.imageSize = CGSizeMake(w, h);
        immessage = imageMessage;
    }
    
    //  发送给聊天页面
    if (immessage) {
        [self.messageStore addMessage:immessage];
        if (self.messageDelegate && [self.messageDelegate respondsToSelector:@selector(didReceivedMessage:)]) {
            [self.messageDelegate didReceivedMessage:immessage];
        }
    }
    
}

- (void)xmppHelper:(IMXMPPHelper *)xmppHelper messageSendFail:(XMPPMessage *)message{
    NSLog(@"messageSendFail ===> %@",message);
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
