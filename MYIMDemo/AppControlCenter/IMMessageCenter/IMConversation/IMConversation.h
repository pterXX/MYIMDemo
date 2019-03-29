//
//  IMConversation.h
//  IMChat
//
//  Created by 徐世杰 on 16/1/23.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  会话类型
 */
typedef NS_ENUM(NSInteger, IMConversationType) {
    IMConversationTypePersonal,     // 个人
    IMConversationTypeGroup,        // 群聊
    IMConversationTypePublic,       // 公众号
    IMConversationTypeServerGroup,  // 服务组（订阅号、企业号）
};

typedef NS_ENUM(NSInteger, IMMessageRemindType) {
    IMMessageRemindTypeNormal,    // 正常接受
    IMMessageRemindTypeClosed,    // 不提示
    IMMessageRemindTypeNoIMook,   // 不看
    IMMessageRemindTypeUnlike,    // 不喜欢
};

@interface IMConversation : NSObject


/**
 *  会话类型（个人，讨论组，企业号）
 */
@property (nonatomic, assign) IMConversationType convType;

/**
 *  消息提醒类型
 */
@property (nonatomic, assign) IMMessageRemindType remindType;

/**
 *  用户ID
 */
@property (nonatomic, strong) NSString *partnerID;

/**
 *  用户名
 */
@property (nonatomic, strong) NSString *partnerName;

/**
 *  头像地址（网络）
 */
@property (nonatomic, strong) NSString *avatarURL;

/**
 *  头像地址（本地）
 */
@property (nonatomic, strong) NSString *avatarPath;

/**
 *  时间
 */
@property (nonatomic, strong) NSDate *date;

/**
 *  消息展示内容
 */
@property (nonatomic, strong) NSString *content;

/**
 *  未读数量
 */
@property (nonatomic, assign) NSInteger unreadCount;
@property (nonatomic, strong, readonly) NSString *badgeValue;
@property (nonatomic, assign, readonly) BOOL isRead;

@end
