//
//  IMUserHelper.h
//  IMChat
//
//  Created by 徐世杰 on 16/2/6.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMUser.h"

@interface IMUserHelper : NSObject

@property (nonatomic, strong) IMUser *user;

@property (nonatomic, strong, readonly) NSString *userID;

@property (nonatomic, assign, readonly) BOOL isLogin;

+ (IMUserHelper *)sharedHelper;


/**
 测试账号
 */
- (void)loginTestAccount;


/**
 退出登录

 @return YES退出成功 ，退出失败
 */
- (BOOL)signUp;

@end
