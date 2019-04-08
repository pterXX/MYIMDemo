//
//  IMMessage.h
//  IMChat
//
//  Created by 徐世杰 on 16/2/15.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMChatUserProtocol.h"
#import "IMMessageProtocol.h"
#import <MapKit/MapKit.h>
#import "IMMessageConstants.h"

/**
 *  消息所有者类型
 */
typedef NS_ENUM(NSInteger, IMPartnerType){
    IMPartnerTypeUser,          // 用户
    IMPartnerTypeGroup,         // 群聊
};

/**
 *  消息拥有者
 */
typedef NS_ENUM(NSInteger, IMMessageOwnerType){
    IMMessageOwnerTypeUnknown,  // 未知的消息拥有者
    IMMessageOwnerTypeSystem,   // 系统消息
    IMMessageOwnerTypeSelf,     // 自己发送的消息
    IMMessageOwnerTypeFriend,   // 接收到的他人消息
};

/**
 *  消息发送状态
 */
typedef NS_ENUM(NSInteger, IMMessageSendState){
    IMMessageSendSuccess,       // 消息发送成功
    IMMessageSendFail,          // 消息发送失败
};

/**
 *  消息读取状态
 */
typedef NS_ENUM(NSInteger, IMMessageReadState) {
    IMMessageUnRead,            // 消息未读
    IMMessageReaded,            // 消息已读
};

@interface IMMessage : NSObject <IMMessageProtocol>
{
    IMMessageFrame *kMessageFrame;
}

@property (nonatomic, strong) NSString *messageID;                  // 消息ID
@property (nonatomic, strong) NSString *userID;                     // 发送者ID
@property (nonatomic, strong) NSString *friendID;                   // 接收者ID
@property (nonatomic, strong) NSString *groupID;                    // 讨论组ID（无则为nil）

@property (nonatomic, strong) NSDate *date;                         // 发送时间

@property (nonatomic, strong) id<IMChatUserProtocol> fromUser;      // 发送者

@property (nonatomic, assign) BOOL showTime;
@property (nonatomic, assign) BOOL showName;

@property (nonatomic, assign) IMPartnerType partnerType;            // 对方类型
@property (nonatomic, assign) IMMessageType messageType;            // 消息类型
@property (nonatomic, assign) IMMessageOwnerType ownerTyper;        // 发送者类型
@property (nonatomic, assign) IMMessageReadState readState;         // 读取状态
@property (nonatomic, assign) IMMessageSendState sendState;         // 发送状态

@property (nonatomic, strong) NSMutableDictionary *content;

@property (nonatomic, strong, readonly) IMMessageFrame *messageFrame;         // 消息frame

+ (IMMessage *)createMessageByType:(IMMessageType)type;

- (void)resetMessageFrame;

@end
