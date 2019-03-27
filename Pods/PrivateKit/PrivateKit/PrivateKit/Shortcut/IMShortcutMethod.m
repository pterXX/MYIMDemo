//
//  IMShortcutMethod.m
//  MYIMDemo
//
//  Created by 徐世杰 on 2019/3/1.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "IMShortcutMethod.h"

//  判断是否是刘海屏
BOOL isNotchScreen(){
    if (@available(iOS 11.0, *)) {
        CGFloat a =  [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom;
        return a > 0.0;
    } else {
        return NO;
    }
}


UINavigationController *addNavigationController(UIViewController *viewController)
{
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:viewController];
    return navC;
}


void initTabBarItem(UITabBarItem *tabBarItem, NSString *tilte, NSString *image, NSString *imageHL) {
    [tabBarItem setTitle:tilte];
    [tabBarItem setImage:[UIImage imageNamed:image]];
    [tabBarItem setSelectedImage:[UIImage imageNamed:imageHL]];
}


//  绘制圆角
void layoutRoundCorner(UIView *view, CGRect rect,CGFloat cornerRadii){
    // 贝塞尔曲线绘制圆角
    UIBezierPath *maskPath  = [UIBezierPath bezierPathWithRoundedRect:rect  byRoundingCorners:UIRectCornerAllCorners  cornerRadii:CGSizeMake(cornerRadii, cornerRadii)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path          = maskPath.CGPath;
    view.layer.mask         = maskLayer;
}
