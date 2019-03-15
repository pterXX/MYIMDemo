//
//  UIViewController+Category.h
//  MYIMDemo
//
//  Created by 徐世杰 on 2019/3/1.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Category)
//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC;

/**
 alert 弹出框
 
 @param title 提示标题
 @param message 提示内容
 @param block 回调
 */
- (void)alertWithTitle:(NSString *)title message:(NSString *)message cancel:(void (^)(BOOL))block;


/**
 重新设置window 的根视图 并伴随淡入淡出的动画
 
 @param rootViewController 需要切换的视图
 */
- (void)restoreRootViewController:(UIViewController *)rootViewController;
@end


@interface UIViewController (NavBar)

/// 添加消失BarButton（左侧)
- (void)addDismissBarButtonWithTitle:(NSString *)title;

/// 左侧文字BarButton
- (void)addLeftBarButtonWithTitle:(NSString *)title actionBlick:(IMBarButtonItemActionCallBack)actionBlock;
/// 左侧图片BarButton
- (void)addLeftBarButtonWithImage:(UIImage *)image actionBlick:(IMBarButtonItemActionCallBack)actionBlock;

/// 右侧文字BarButton
- (void)addRightBarButtonWithTitle:(NSString *)title actionBlick:(IMBarButtonItemActionCallBack)actionBlock;
/// 右侧图片BarButton
- (void)addRightBarButtonWithImage:(UIImage *)image actionBlick:(IMBarButtonItemActionCallBack)actionBlock;

@end
NS_ASSUME_NONNULL_END
