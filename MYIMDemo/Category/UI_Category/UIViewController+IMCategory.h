//
//  UIViewController+IMCategory.h
//  MYIMDemo
//
//  Created by 徐世杰 on 2019/3/1.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (IMCategory)
//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC;

/**
 alert 弹出框
 
 @param title 提示标题
 @param message 提示内容
 @param block 回调
 */
- (void)alertWithTitle:(NSString *)title message:(NSString *)message cancel:(void (^)(BOOL))block;
@end

NS_ASSUME_NONNULL_END
