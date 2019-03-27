//
//  UIScrollView+IMLoadMoreFooter.m
//  IMChat
//
//  Created by 李伯坤 on 2017/7/21.
//  Copyright © 2017年 李伯坤. All rights reserved.
//

#import "UIScrollView+IMLoadMoreFooter.h"
#import <MJRefresh/MJRefresh.h>

@implementation UIScrollView (IMLoadMoreFooter)

- (void)tt_addLoadMoreFooterWithAction:(void (^)())loadMoreAction
{
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:loadMoreAction];
    [footer setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多数据了" forState:MJRefreshStateNoMoreData];
    [self setMj_footer:footer];
}

- (void)tt_beginLoadMore
{
    [self.mj_footer beginRefreshing];
}

- (void)tt_endLoadMore
{
    [self.mj_footer endRefreshing];
}

- (void)tt_showNoMoreFooter
{
    [self.mj_footer endRefreshingWithNoMoreData];
}

- (void)tt_showNoMoreFooterWithtitle:(NSString *)title
{
    MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)self.mj_footer;
    [footer setTitle:title forState:MJRefreshStateNoMoreData];
    [self tt_showNoMoreFooter];
}

- (void)tt_removeLoadMoreFooter
{
    [self setMj_footer:nil];
}

@end
