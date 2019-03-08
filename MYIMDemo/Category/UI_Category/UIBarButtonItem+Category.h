//
//  UIBarButtonItem+Category.h
//  MYIMDemo
//
//  Created by admin on 2019/3/7.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^IMBarButtonItemActionCallBack)(UIBarButtonItem *barItem);

@interface UIBarButtonItem (Category)
/**
 带文字的barButtonImage
 @param barTitle 当前需要显示的文字
 @param callBack 点击UIBarButtonItem 后的回调
 @return UIBarButtonItem
 */
+ (UIBarButtonItem *)barTitle:(NSString *)barTitle
                     callBack:(IMBarButtonItemActionCallBack)callBack;


/**
 带图片的barButtonImage
 @param barImage 当前需要显示图片
 @param callBack 点击UIBarButtonItem 后的回调
 @return UIBarButtonItem
 */
+ (UIBarButtonItem *)barImage:(UIImage *)barImage
                     callBack:(IMBarButtonItemActionCallBack)callBack;
@end

NS_ASSUME_NONNULL_END
