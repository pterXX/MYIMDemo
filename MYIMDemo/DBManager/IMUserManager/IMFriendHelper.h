//
//  IMFriendHelper.h
//  IMChat
//
//  Created by 徐世杰 on 16/1/27.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMUserGroup.h"
#import "IMGroup.h"

@interface IMFriendHelper : NSObject

#pragma mark - # 好友

/// 好友数据(原始)
@property (nonatomic, strong, readonly) NSMutableArray *friendsData;

/// 格式化的好友数据（二维数组，列表用）
@property (nonatomic, strong) NSMutableArray *data;

/// 格式化好友数据的分组标题
@property (nonatomic, strong) NSMutableArray *sectionHeaders;

///  好友数量
@property (nonatomic, assign, readonly) NSInteger friendCount;

@property (nonatomic, strong) void(^dataChangedBlock)(NSMutableArray *friends, NSMutableArray *headers, NSInteger friendCount);


#pragma mark - # 群
/// 群数据
@property (nonatomic, strong) NSMutableArray *groupsData;


#pragma mark - # 标签
/// 标签数据
@property (nonatomic, strong) NSMutableArray *tagsData;


+ (IMFriendHelper *)sharedFriendHelper;

- (IMUser *)getFriendInfoByUserID:(NSString *)userID;

- (IMGroup *)getGroupInfoByGroupID:(NSString *)groupID;

- (BOOL)deleteFriendByUserId:(NSString *)userID;

@end