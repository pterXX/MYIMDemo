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

@end
