//
//  IMDBFriendStore.m
//  IMChat
//
//  Created by 徐世杰 on 16/3/22.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "IMDBFriendStore.h"
#import "IMDBFriendSQL.h"
#import "IMDBManager.h"
#import "IMUser.h"

@implementation IMDBFriendStore

- (id)init
{
    if (self = [super init]) {
        self.dbQueue = [IMDBManager sharedInstance].commonQueue;
        BOOL ok = [self createTable];
        if (!ok) {
            NSLog(@"DB: 好友表创建失败");
        }
    }
    return self;
}

- (BOOL)createTable
{
    NSString *sqlString = [NSString stringWithFormat:SQL_CREATE_FRIENDS_TABLE, FRIENDS_TABLE_NAME];
    return [self createTable:FRIENDS_TABLE_NAME withSQL:sqlString];
}

- (BOOL)addFriend:(IMUser *)user forUid:(NSString *)uid
{
    NSString *sqlString = [NSString stringWithFormat:SQL_UPDATE_FRIEND, FRIENDS_TABLE_NAME];
    NSArray *arrPara = [NSArray arrayWithObjects:
                        IMNoNilString(uid),
                        IMNoNilString(user.userID),
                        IMNoNilString(user.username),
                        IMNoNilString(user.nikeName),
                        IMNoNilString(user.avatarURL),
                        IMNoNilString(user.remarkName),
                        IMNoNilString(user.subscription)
                        , @"", @"", @"", @"", nil];
    BOOL ok = [self excuteSQL:sqlString withArrParameter:arrPara];
    return ok;
}

- (BOOL)updateFriendsData:(NSArray *)friendData forUid:(NSString *)uid
{
    NSArray *oldData = [self friendsDataByUid:uid];
    if (oldData.count > 0) {
        // 建立新数据的hash表，用于删除数据库中的过时数据
        NSMutableDictionary *newDataHash = [[NSMutableDictionary alloc] init];
        for (IMUser *user in friendData) {
            [newDataHash setValue:@"YES" forKey:user.userID];
        }
        for (IMUser *user in oldData) {
            if ([newDataHash objectForKey:user.userID] == nil) {
                BOOL ok = [self deleteFriendByFid:user.userID forUid:uid];
                if (!ok) {
                    NSLog(@"DBError: 删除过期好友失败");
                }
            }
        }
    }
    
    for (IMUser *user in friendData) {
        BOOL ok = [self addFriend:user forUid:uid];
        if (!ok) {
            return ok;
        }
    }
    
    return YES;
}

- (NSMutableArray *)friendsDataByUid:(NSString *)uid
{
    __block NSMutableArray *data = [[NSMutableArray alloc] init];
    NSString *sqlString = [NSString stringWithFormat:SQL_SELECT_FRIENDS, FRIENDS_TABLE_NAME, uid];
    
    [self excuteQuerySQL:sqlString resultBlock:^(FMResultSet *retSet) {
        while ([retSet next]) {
            IMUser *user = [[IMUser alloc] init];
            user.userID = [retSet stringForColumn:@"uid"];
            user.username = [retSet stringForColumn:@"username"];
            user.nikeName = [retSet stringForColumn:@"nikename"];
            user.avatarURL = [retSet stringForColumn:@"avatar"];
            user.avatarPath = [retSet stringForColumn:@"avatar"];
            user.remarkName = [retSet stringForColumn:@"remark"];
            user.subscription = [retSet stringForColumn:@"subscription"];
            [data addObject:user];
        }
        [retSet close];
    }];
    
    return data;
}

- (BOOL)deleteFriendByFid:(NSString *)fid forUid:(NSString *)uid
{
    NSString *sqlString = [NSString stringWithFormat:SQL_DELETE_FRIEND, FRIENDS_TABLE_NAME, uid, fid];
    BOOL ok = [self excuteSQL:sqlString, nil];
    return ok;
}

@end
