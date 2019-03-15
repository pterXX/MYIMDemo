//
//  UIBarButtonItem+Category.h
//  MYIMDemo
//
//  Created by admin on 2019/3/7.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^IMBarButtonItemActionCallBack)(void);

@interface UIBarButtonItem (Category)

+ (id)fixItemSpace:(CGFloat)space;

- (id)initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style actionBlick:(IMBarButtonItemActionCallBack)actionBlock;

- (id)initWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style actionBlick:(IMBarButtonItemActionCallBack)actionBlock;

- (void)setActionBlock:(IMBarButtonItemActionCallBack)actionBlock;
@end

NS_ASSUME_NONNULL_END
