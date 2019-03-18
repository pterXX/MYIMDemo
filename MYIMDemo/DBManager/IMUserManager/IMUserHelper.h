//
//  IMUserHelper.h
//  IMChat
//
//  Created by 徐世杰 on 16/2/6.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMUser.h"
#import "IMUserGroup.h"

@interface IMUserHelper : NSObject

@property (nonatomic, strong) IMUser *user;

@property (nonatomic ,strong) NSString  *userAccount;

@property (nonatomic ,strong) NSString  *password;

@property (nonatomic, strong, readonly) NSString *userID;

@property (nonatomic, assign, readonly) BOOL isLogin;


//  好友列表
@property (nonatomic, strong) NSMutableArray<IMUser *>  *allFriendArray;
@property (nonatomic, strong) NSMutableArray<IMUser *>  *bothFriendArray; // both
@property (nonatomic, strong) NSMutableArray<IMUser *>  *noneFriendArray; // None
@property (nonatomic, strong) NSMutableArray<IMUser *>  *toFriendArray;  // to
@property (nonatomic, strong) NSMutableArray<IMUser *>  *fromFriendArray; // from
@property (nonatomic, strong) NSMutableArray<IMUser *>  *removeFriendArray; // Remove

//  根据allFriendArray 排序后的数组
@property (nonatomic, strong ,readonly) NSArray<IMUser *> *sortArray;
@property (nonatomic, strong ,readonly) NSArray <IMUserGroup *> *sortGroupArray;
@property (nonatomic, strong ,readonly) NSArray <NSString *> *pinyinInitialArray;


//  添加好友数据
@property (nonatomic, strong) NSMutableArray<XMPPJID *> *addFriendJidArray;

+ (IMUserHelper *)sharedHelper;

/**
 测试账号
 */
- (void)loginTestAccount;


/**
 退出登录

 @return YES退出成功 ，退出失败
 */
- (BOOL)signOut;

/**
 清空所有好友
 */
- (void)clearFriendArray;
@end
