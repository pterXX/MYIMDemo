//
//  IMNotificationHeader.h
//  MYIMDemo
//
//  Created by admin on 2019/3/25.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#ifndef IMNotificationHeader_h
#define IMNotificationHeader_h

#pragma mark - 消息部分常量定义
//  消息列表 elementWithName
static NSString *const kMessageElementDataBodyName  = @"dataBody";
static NSString *const kConversationCommonNot = @"conversationCommonNot";
//  好友列表改变是会执行相应的通知
static NSString *const kXmppRosterChangeNot = @"kXmppRosterChange";
//  收到好友订阅请求是会执行这个通知
static NSString *const kXmppSubscriptionRequestNot = @"kXmppSubscriptionRequest";
//  上线通知
static NSString *const kXmppContactIsAvailableNot = @"kXmppContactIsAvailable";
//  会话列表改变
static NSString *const kConversationDataChangedNot = @"kConversationDataChangedNot";

//  全部消息接收是发出通知
static NSString *const kChatDidReceiveMessageNot = @"kChatDidReceiveMessageNot";
//  当前聊天用户接收到消息发布通知
static NSString *const kChatUserDidReceiveMessageNot = @"kChatUserDidReceiveMessageNot";

//  消息发送成功
static NSString *const kChatDidSendMessageNot = @"kChatDidSendMessageNot";
//  消息发送失败
static NSString *const kChatDidFailToSendMessageNot = @"kChatDidFailToSendMessageNot";
static NSString *const kChatUserDidFailToSendMessageNot = @"kChatUserDidFailToSendMessageNot";

#endif /* IMNotificationHeader_h */
