//
//  IMChatBaseViewController.m
//  MYIMDemo
//
//  Created by 徐世杰 on 2019/3/1.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "IMChatBaseViewController.h"
#import "IMSystemAuthorization.h"
@interface IMChatBaseViewController ()

@end

@implementation IMChatBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isExtendLayout = NO;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.view.backgroundColor = KBGColor;
    // 设置导航栏颜色
    self.navigationController.navigationBar.barTintColor = KNavigationColor;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontNavBarTitle],NSForegroundColorAttributeName:[UIColor colorTextBlack]}];
    
    // 设置导航按钮颜色
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    // 设置导航按钮字体
    UIBarButtonItem *barItem = [UIBarButtonItem appearance];
    [barItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontNavBarTitle]} forState:UIControlStateNormal];
    [barItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontNavBarTitle]} forState:UIControlStateHighlighted];
    //取消手势返回
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

/**
 权限设置
 
 @param title 提示标题
 @param message 提示内容
 @param block 回调
 */
- (void)settingAuthorizationWithTitle:(NSString *)title message:(NSString *)message cancel:(void (^)(BOOL))block
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        block(YES);
    }];
    UIAlertAction *setting = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        block(NO);
        [[IMSystemAuthorization shareInstance] requetSettingForAuth];
    }];
    
    [alertController addAction:cancel];
    [alertController addAction:setting];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

@end
