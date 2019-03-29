//
//  UIView+IMEmpty.m
//  IMChat
//
//  Created by 徐世杰 on 2017/7/23.
//  Copyright © 2017年 徐世杰. All rights reserved.
//

#import "UIView+IMEmpty.h"
#import "UIView+Extensions.h"

@implementation UIView (IMEmpty)

- (void)showEmptyViewWithTitle:(NSString *)title
{
    CGRect rect = CGRectEqualToRect(self.bounds, CGRectZero) ? CGRectMake(15, 0, IMSCREEN_WIDTH - 30, IMSCREEN_HEIGHT - IMSTATUSBAR_HEIGHT - IMNAVBAR_HEIGHT) : self.bounds;
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    [label setNumberOfLines:0];
    [label setFont:[UIFont systemFontOfSize:16]];
    [label setTextColor:[UIColor grayColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setText:title ? title : @"没有请求到相应数据"];
    [self showTipView:label retryAction:nil];
}

- (void)showErrorViewWithTitle:(NSString *)title
{
    [self showErrorViewWithTitle:title retryAction:nil];
}

- (void)showErrorViewWithTitle:(NSString *)title retryAction:(void (^)(id userData))retryAction
{
    [self showErrorViewWithTitle:title userData:nil retryAction:retryAction];
}

- (void)showErrorViewWithTitle:(NSString *)title userData:(id)userData retryAction:(void (^)(id userData))retryAction
{
    CGRect rect = CGRectEqualToRect(self.bounds, CGRectZero) ? CGRectMake(15, 0, SCREEN_WIDTH - 30, SCREEN_HEIGHT - IMSTATUSBAR_HEIGHT - IMNAVBAR_HEIGHT) : self.bounds;
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    [label setNumberOfLines:0];
    [label setFont:[UIFont systemFontOfSize:16]];
    [label setTextColor:[UIColor grayColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [self showTipView:label userData:userData retryAction:retryAction];
}

@end

