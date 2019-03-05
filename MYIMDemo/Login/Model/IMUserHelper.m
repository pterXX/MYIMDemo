//
//  IMUserHelper.m
//  MYIMDemo
//
//  Created by admin on 2019/3/5.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "IMUserHelper.h"


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
    user.avatarUrl = @"http://p1.qq181.com/cms/120506/2012050623111097826.jpg";
    user.nickName = @"徐青松";
    user.userName = @"xu-qingsong";
    [self setUser:user];
}

- (void)setUser:(IMUser *)user
{
    _user = user;
    TLDBUserStore *userStore = [[TLDBUserStore alloc] init];
    if (![userStore updateUser:user]) {
        DDLogError(@"登录数据存库失败");
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:user.userID forKey:@"loginUid"];
}

- (TLUser *)user
{
    if (!_user) {
        if (self.userID.length > 0) {
            TLDBUserStore *userStore = [[TLDBUserStore alloc] init];
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
