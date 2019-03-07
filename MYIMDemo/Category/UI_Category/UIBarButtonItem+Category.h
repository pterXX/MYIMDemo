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
+ (UIBarButtonItem *)barTitle:(NSString *)barTitle
                     callBack:(IMBarButtonItemActionCallBack)callBack;
@end

NS_ASSUME_NONNULL_END
