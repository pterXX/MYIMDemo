//
//  UIScrollView+IMRefreshHeader.m
//  IMChat
//
//  Created by 李伯坤 on 2017/7/21.
//  Copyright © 2017年 李伯坤. All rights reserved.
//

#import "UIScrollView+IMRefreshHeader.h"
#import <MJRefresh/MJRefresh.h>

@implementation UIScrollView (IMRefreshHeader)

- (void)tt_addRefreshHeaderWithAction:(void (^)())refreshAction
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:refreshAction];
    [self setMj_header:header];
}

- (void)tt_beginRefreshing
{
    [self.mj_header beginRefreshing];
}

- (void)tt_endRefreshing
{
    [self.mj_header endRefreshing];
}

- (void)tt_removeRefreshHeader
{
    [self setMj_header:nil];
}

@end
