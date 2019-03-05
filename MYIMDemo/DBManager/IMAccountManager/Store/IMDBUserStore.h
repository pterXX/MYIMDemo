//
//  IMDBUserStore.h
//  IMChat
//
//  Created by 徐世杰 on 2017/3/21.
//  Copyright © 2017年 徐世杰. All rights reserved.
//

#import "IMDBBaseStore.h"

@class IMUser;
@interface IMDBUserStore : IMDBBaseStore

/**
 *  更新用户信息
 */
- (BOOL)updateUser:(IMUser *)user;

/**
 *  获取用户信息
 */
- (IMUser *)userByID:(NSString *)userID;

/**
 *  查询所有用户
 */
- (NSArray *)userData;

/**
 *  删除用户
 */
- (BOOL)deleteUsersByUid:(NSString *)uid;

@end
