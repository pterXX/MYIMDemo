//
//  IMUserHelper.m
//  IMChat
//
//  Created by 徐世杰 on 16/2/6.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "IMUserHelper.h"
#import "IMDBUserStore.h"

#define KLoginUid @"loginUid"
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
    user.userID              = @"admin1@admins";
    user.avatarURL           = @"http://p1.qq181.com/cms/120506/2012050623111097826.jpg";
    user.nikeName            = @"徐世杰";
    user.username            = @"xuqinngsong";
    user.detailInfo.qqNumber = @"7281023814";
    user.detailInfo.email    = @"7281023814@qq.com";
    user.detailInfo.location = @"垫江";
    user.detailInfo.sex      = @"男";
    user.detailInfo.motto    = @"Hello world!";
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
    
    [[NSUserDefaults standardUserDefaults] setObject:user.userID forKey:KLoginUid];
}

- (IMUser *)user{
    if (!_user) {
        if (self.userID.length > 0) {
            IMDBUserStore *userStore = [[IMDBUserStore alloc] init];
            _user = [userStore userByID:self.userID];
            if (!_user) {
                [IMUserDefaults removeObjectForKey:KLoginUid];
            }
        }
    }
    return _user;
}

- (NSString *)userID{
    NSString *uid = [IMUserDefaults objectForKey:KLoginUid];
    return uid;
}

- (BOOL)isLogin{
    return self.user.userID.length > 0;
}

- (BOOL)signOut{
    BOOL ok = YES;
    if (self.isLogin || self.userID) {
        IMDBUserStore *userStore = [[IMDBUserStore alloc] init];
        if (![userStore deleteUsersByUid:self.userID]) {
            DDLogError(@"登录数据存库失败");
            ok = NO;
        }else{
            [IMUserDefaults removeObjectForKey:KLoginUid];
        }
    }
    return ok;
}

@end
