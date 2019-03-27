//
//  IMLaunchManager.m
//  IMChat
//
//  Created by 李伯坤 on 2017/9/19.
//  Copyright © 2017年 李伯坤. All rights reserved.
//

#import "IMLaunchManager.h"
#import "IMLoginViewController.h"
#import "IMConversationViewController.h"
#import "IMContactsViewController.h"

#if __has_include(<AVOSCloud/AVOSCloud.h>)
#import <AVOSCloud/AVOSCloud.h>
#endif

@interface IMLaunchManager ()

@property (nonatomic, weak) UIWindow *window;

@end

@implementation IMLaunchManager
@synthesize tabBarController = _tabBarController;

+ (IMLaunchManager *)sharedInstance
{
    static IMLaunchManager *rootVCManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        rootVCManager = [[self alloc] init];
    });
    return rootVCManager;
}

- (void)launchInWindow:(UIWindow *)window
{
    self.window = window;
    if ([IMUserHelper sharedHelper].isLogin) {      // 已登录
        [self p_createTabBarChildViewController];
#if __has_include(<AVOSCloud/AVOSCloud.h>)
        [self p_initAVOSCloud];
#endif
        [self setCurRootVC:self.tabBarController];
        
        // 初始化用户信息
//        [self initUserData];
    }
    else {  // 未登录
        IMLoginViewController *accountVC = [[IMLoginViewController alloc] init];
        @weakify(self);
        [accountVC setLoginSuccessBlock:^{
            @strongify(self);
            [self launchInWindow:window];
        }];
        [self setCurRootVC:accountVC];
    }
}

- (void)setCurRootVC:(__kindof UIViewController *)curRootVC
{
    _curRootVC = curRootVC;
    
    {
        UIWindow *window = self.window ? self.window : [UIApplication sharedApplication].keyWindow;
        [window removeAllSubviews];
        [window setRootViewController:curRootVC];
        [window addSubview:curRootVC.view];
        [window makeKeyAndVisible];
    }
}

#pragma mark - # Private Methods
- (void)p_createTabBarChildViewController
{
    IMBaseNavigationController *messages = [IMConversationViewController navVc];
    [self.tabBarController addSubController:messages action:^(UITabBarItem * _Nonnull item, UITabBarController * _Nonnull tabbarVc) {
        
    }];
    
    IMBaseNavigationController *addresBooks = [IMContactsViewController navVc];
    [self.tabBarController  addSubController:addresBooks action:^(UITabBarItem * _Nonnull item, UITabBarController * _Nonnull tabbarVc) {
        
    }];
}

#if __has_include(<AVOSCloud/AVOSCloud.h>)
- (void)p_initAVOSCloud{
    
    [AVOSCloud setApplicationId:@"AcK0Rp92CbGATVRmdzO7r6jV-gzGzoHsz" clientKey:@"iiuWcKQVjsz4rtnyBO0HuoPU"];
}
#endif


#pragma mark - # Getters
- (IMBaseTabBarController *)tabBarController
{
    if (!_tabBarController) {
        IMBaseTabBarController *tabbarController = [[IMBaseTabBarController alloc] init];
        [tabbarController.tabBar setBackgroundColor:[UIColor colorGrayBG]];
        [tabbarController.tabBar setTintColor:[UIColor colorGreenDefault]];
        _tabBarController = tabbarController;
    }
    return _tabBarController;
}

@end

