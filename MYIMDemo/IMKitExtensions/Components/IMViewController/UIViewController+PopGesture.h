//
//  UIViewController+PopGesture.h
//  IMChat
//
//  Created by 徐世杰 on 2017/9/26.
//  Copyright © 2017年 徐世杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (PopGesture) <UIGestureRecognizerDelegate>

/// 禁用手势返回（默认为NO）
@property (nonatomic, assign) BOOL disablePopGesture;

@end
