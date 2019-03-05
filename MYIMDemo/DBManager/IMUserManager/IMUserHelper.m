//
//  IMUserHelper.m
//  IMChat
//
//  Created by 徐世杰 on 16/2/6.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "IMUserHelper.h"
#import "IMDBUserStore.h"

@implementation IMUserHelper
@synthesize user = _user;

+ (IMUserHelper *)sharedHelper
{
    static IMUserHelper *helper;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        helper = [[IMUserHelper alloc] init];
    });
    return helper;
}

- (void)loginTestAccount
{
    IMUser *user = [[IMUser alloc] init];
    user.userID = @"1000";
    user.avatarURL = @"http://p1.qq181.com/cms/120506/2012050623111097826.jpg";
    user.nikeName = @"徐世杰";
    user.username = @"li-bokun";
    user.detailInfo.qqNumber = @"1159197873";
    user.detailInfo.email = @"libokun@126.com";
    user.detailInfo.location = @"山东 滨州";
    user.detailInfo.sex = @"男";
    user.detailInfo.motto = @"Hello world!";
    user.detailInfo.momentsWallURL = @"http://pic1.win4000.com/wallpaper/c/5791e49b37a5c.jpg";

    [self setUser:user];
}

- (void)setUser:(IMUser *)user
{
    _user = user;
    IMDBUserStore *userStore = [[IMDBUserStore alloc] init];
    if (![userStore updateUser:user]) {
        DDLogError(@"登录数据存库失败");
    }

    [[NSUserDefaults standardUserDefaults] setObject:user.userID forKey:@"loginUid"];
}
- (IMUser *)user
{
    if (!_user) {
        if (self.userID.length > 0) {
            IMDBUserStore *userStore = [[IMDBUserStore alloc] init];
            _user = [userStore userByID:self.userID];
            _user.detailInfo.momentsWallURL = @"http://pic1.win4000.com/wallpaper/c/5791e49b37a5c.jpg";
            if (!_user) {
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"loginUid"];
            }
        }
    }
    return _user;
}

- (NSString *)userID
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginUid"];
    return uid;
}

- (BOOL)isLogin
{
    return self.user.userID.length > 0;
}

@end