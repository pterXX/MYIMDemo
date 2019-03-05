//
//  UIFont+IMChat.h
//  MYIMDemo
//
//  Created by 徐世杰 on 2019/3/1.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import <UIKit/UIKit.h>
// 字体大小
static const CGFloat KSystemFontOfSize32     = 32;
static const CGFloat KSystemFontOfSize16     = 16;
static const CGFloat KSystemFontOfSize14     = 14;
static const CGFloat KSystemFontOfSize13     = 13;
static const CGFloat KSystemFontOfSize12     = 12;
static const CGFloat KSystemFontOfSize10     = 10;
static const CGFloat KBoldSystemFontOfSize16 = 16;
static const CGFloat KBoldSystemFontOfSize14 = 14;
static const CGFloat KBoldSystemFontOfSize13 = 12;

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (IMChat)
#pragma mark - Common
+ (UIFont *)fontNavBarTitle;

#pragma mark - Login
+ (UIFont *) fontLoginLogo;
+ (UIFont *) fontLoginUserAndPassword;

#pragma mark - Message list
+ (UIFont *) fontMessageListUpdateTime;
+ (UIFont *) fontMessageListTitle;
+ (UIFont *) fontMessageListBadgeNumber;
@end

NS_ASSUME_NONNULL_END
