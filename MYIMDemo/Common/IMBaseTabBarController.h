//
//  IMBaseTabBarController.h
//  MYIMDemo
//
//  Created by admin on 2019/3/8.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMMessageViewController.h"
#import "IMAddressBookViewController.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^IMBaseTabBarCtrSubVcAction)(UITabBarItem *item,UITabBarController *tabbarVc);
@interface IMBaseTabBarController : UITabBarController

/**
 添加视图控制器

 @param vc 当前的视图控制器
 @param action 点击当前的vc所执行的操作
 */
- (void)addSubController:( UIViewController * _Nonnull )vc action:(_Nonnull IMBaseTabBarCtrSubVcAction)action;

/**
 初始化控制tabbar

 @param controller 控制器
 @param title 标题
 @param image 图片
 @param selectedImage 选中图片
 @param textColor 字体颜色
 */
- (void)controller:(UIViewController *)controller
             Title:(NSString *)title
   tabBarItemImage:(UIImage *)image
tabBarItemSelectedImage:(UIImage *)selectedImage
         textColor:(UIColor *)textColor;
@end


@interface IMBaseTabBarController(Class)
+ (IMBaseTabBarController *)tabbarVc;
@end
NS_ASSUME_NONNULL_END
