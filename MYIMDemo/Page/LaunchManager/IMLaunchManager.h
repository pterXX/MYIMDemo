//
//  IMLaunchManager.h
//  IMChat
//
//  Created by 李伯坤 on 2017/9/19.
//  Copyright © 2017年 李伯坤. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMLaunchManager : NSObject

/// 当前根控制器
@property (nonatomic, strong, readonly) __kindof UIViewController *curRootVC;

/// 根tabBarController
@property (nonatomic, strong, readonly) IMBaseTabBarController *tabBarController;

+ (IMLaunchManager *)sharedInstance;

/**
 *  启动，初始化
 */
- (void)launchInWindow:(UIWindow *)window;


- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end
