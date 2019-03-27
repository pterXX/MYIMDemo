//
//  UIScrollView+IMLoadMoreFooter.h
//  IMChat
//
//  Created by 李伯坤 on 2017/7/21.
//  Copyright © 2017年 李伯坤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (IMLoadMoreFooter)

- (void)tt_addLoadMoreFooterWithAction:(void (^)())loadMoreAction;
- (void)tt_beginLoadMore;
- (void)tt_endLoadMore;
- (void)tt_showNoMoreFooter;
- (void)tt_showNoMoreFooterWithtitle:(NSString *)title;
- (void)tt_removeLoadMoreFooter;

@end
