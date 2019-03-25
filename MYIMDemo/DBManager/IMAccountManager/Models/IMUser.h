//
//  IMUser.h
//  IMChat
//
//  Created by 徐世杰 on 16/1/23.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XMPPFramework/XMPPFramework.h>
#import <MJExtension/MJExtension.h>
#import <PrivateKit/IMCategory.h>   //  私有库, 常用分类

#import "IMUserDetail.h"
#import "IMUserSetting.h"
#import "IMUserChatSetting.h"

@interface IMUser : NSObject

/// 用户ID
@property (nonatomic, strong) XMPPJID *userJid;

/// 用户ID
@property (nonatomic, strong) NSString *userID;

/// 用户名
@property (nonatomic, strong) NSString *username;

/// 昵称
@property (nonatomic, strong) NSString *nikeName;

/// 头像
@property (nonatomic, strong) UIImage *avatar;

/// 头像URL
@property (nonatomic, strong) NSString *avatarURL;

/// 头像Path
@property (nonatomic, strong) NSString *avatarPath;

/// 备注名
@property (nonatomic, strong) NSString *remarkName;

/// 界面显示名称
@property (nonatomic, strong, readonly) NSString *showName;

/// 订阅状态
@property (nonatomic, strong) NSString *subscription;

@property (nonatomic, strong) NSString *ask;

/// 活跃状态
@property (nonatomic, assign) BOOL isAvailable;

#pragma mark - 其他
@property (nonatomic, strong) IMUserDetail *detailInfo;

@property (nonatomic, strong) IMUserSetting *userSetting;

@property (nonatomic, strong) IMUserChatSetting *chatSetting;


#pragma mark - 列表用
/**
 *  拼音  
 *
 *  来源：备注 > 昵称 > 用户名
 */
@property (nonatomic, strong) NSString *pinyin;

@property (nonatomic, strong) NSString *pinyinInitial;

+ (IMUser *)user:(XMPPJID *)jid;

@end
