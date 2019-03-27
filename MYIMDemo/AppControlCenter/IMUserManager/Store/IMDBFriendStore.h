//
//  IMDBFriendStore.h
//  IMChat
//
//  Created by 李伯坤 on 16/3/22.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "IMDBBaseStore.h"

@class IMUser;
@interface IMDBFriendStore : IMDBBaseStore

- (BOOL)updateFriendsData:(NSArray *)friendData
                   forUid:(NSString *)uid;

- (BOOL)addFriend:(IMUser *)user forUid:(NSString *)uid;

- (NSMutableArray *)friendsDataByUid:(NSString *)uid;

- (BOOL)deleteFriendByFid:(NSString *)fid forUid:(NSString *)uid;

@end
