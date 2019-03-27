//
//  IMDBManager.m
//  IMChat
//
//  Created by 李伯坤 on 16/3/13.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "IMDBManager.h"
#import "IMUserHelper.h"
#import "NSFileManager+IMChat.h"

static IMDBManager *manager;

@implementation IMDBManager

+ (IMDBManager *)sharedInstance
{
    static dispatch_once_t once;
    NSString *userID = [IMUserHelper sharedHelper].userID;
    dispatch_once(&once, ^{
        manager = [[IMDBManager alloc] initWithUserID:userID];
    });
    return manager;
}

- (id)initWithUserID:(NSString *)userID
{
    if (self = [super init]) {
        NSString *commonQueuePath = [NSFileManager pathDBCommon];
        self.commonQueue = [FMDatabaseQueue databaseQueueWithPath:commonQueuePath];
        NSString *messageQueuePath = [NSFileManager pathDBMessage];
        self.messageQueue = [FMDatabaseQueue databaseQueueWithPath:messageQueuePath];
    }
    return self;
}

- (id)init
{
    DDLogError(@"IMDBManager：请使用 initWithUserID: 方法初始化");
    return nil;
}

@end
