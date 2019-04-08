//
//  UIScrollView+IMRefreshHeader.h
//  IMChat
//
//  Created by 徐世杰 on 2017/7/21.
//  Copyright © 2017年 徐世杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (IMRefreshHeader)

- (void)tt_addRefreshHeaderWithAction:(void (^)())refreshAction;
- (void)tt_beginRefreshing;
- (void)tt_endRefreshing;
- (void)tt_removeRefreshHeader;

@end
