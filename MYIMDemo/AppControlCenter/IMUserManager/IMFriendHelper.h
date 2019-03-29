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


//  好友列表
@property (nonatomic, strong) NSMutableArray<IMUser *>  *allFriendArray;
@property (nonatomic, strong) NSMutableArray<IMUser *>  *bothFriendArray; // both
@property (nonatomic, strong) NSMutableArray<IMUser *>  *noneFriendArray; // None
@property (nonatomic, strong) NSMutableArray<IMUser *>  *toFriendArray;  // to
@property (nonatomic, strong) NSMutableArray<IMUser *>  *fromFriendArray; // from
@property (nonatomic, strong) NSMutableArray<IMUser *>  *removeFriendArray; // Remove
//  好友总数量
@property (nonatomic, assign ,readonly) NSInteger totalCount;
//  根据allFriendArray 排序后的数组
@property (nonatomic, strong ,readonly) NSMutableArray <IMUser *> *sortArray;
@property (nonatomic, strong ,readonly) NSMutableArray <IMUserGroup *> *sortGroupArray;
@property (nonatomic, strong ,readonly) NSMutableArray <NSString *> *pinyinInitialArray;

//  添加好友数据
@property (nonatomic, strong) NSMutableArray<XMPPJID *> *addFriendJidArray;


@property (nonatomic, strong) void(^dataChangedBlock)(NSArray *friends, NSArray *headers, NSInteger friendCount);


#pragma mark - # 群
/// 群数据
@property (nonatomic, strong) NSMutableArray *groupsData;


#pragma mark - # 标签
/// 标签数据
@property (nonatomic, strong) NSMutableArray *tagsData;


+ (IMFriendHelper *)sharedFriendHelper;

- (BOOL)updateFriendsByArray:(NSArray *)array userID:(NSString *)userID;

- (IMUser *)getFriendInfoByUserID:(NSString *)userID;

- (IMGroup *)getGroupInfoByGroupID:(NSString *)groupID;

- (BOOL)deleteFriendByUserId:(NSString *)userID;
@end
