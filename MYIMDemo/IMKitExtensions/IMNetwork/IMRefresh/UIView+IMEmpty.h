//
//  UIView+IMEmpty.h
//  IMChat
//
//  Created by 徐世杰 on 2017/7/23.
//  Copyright © 2017年 徐世杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (IMEmpty)

- (void)showEmptyViewWithTitle:(NSString *)title;

- (void)showErrorViewWithTitle:(NSString *)title retryAction:(void (^)(id userData))retryAction;
- (void)showErrorViewWithTitle:(NSString *)title userData:(id)userData retryAction:(void (^)(id userData))retryAction;

@end
