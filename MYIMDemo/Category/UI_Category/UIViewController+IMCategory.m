//
//  UIViewController+IMCategory.m
//  MYIMDemo
//
//  Created by 徐世杰 on 2019/3/1.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "UIViewController+IMCategory.h"

@implementation UIViewController (IMCategory)

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC
{
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}

/**
 alert 弹出框
 
 @param title 提示标题
 @param message 提示内容
 @param block 回调
 */
- (void)alertWithTitle:(NSString *)title message:(NSString *)message cancel:(void (^)(BOOL))block
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        block(YES);
    }];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        block(NO);
    }];
    [alertController addAction:cancel];
    [alertController addAction:sure];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
