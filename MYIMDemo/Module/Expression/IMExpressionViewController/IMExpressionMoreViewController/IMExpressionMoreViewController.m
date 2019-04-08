//
//  IMExpressionMoreViewController.m
//  IMChat
//
//  Created by 徐世杰 on 2017/7/18.
//  Copyright © 2017年 徐世杰. All rights reserved.
//

#import "IMExpressionMoreViewController.h"
#import "IMExpressionDetailViewController.h"
#import "IMExpressionGroupModel+MoreRequest.h"
#import "UIView+IMEmpty.h"

typedef NS_ENUM(NSInteger, IMExpressionMoreSectionType) {
    IMExpressionMoreSectionTypeSearch,
    IMExpressionMoreSectionTypeExprs,
};

@interface IMExpressionMoreViewController ()

@property (nonatomic, assign) NSInteger pageIndex;

@end

@implementation IMExpressionMoreViewController

- (void)loadView
{
    [super loadView];
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    
    @weakify(self);
    // 搜索
    self.addSection(IMExpressionMoreSectionTypeSearch);
    self.addCell(@"IMExpressionMoreSearchCell").toSection(IMExpressionMoreSectionTypeSearch).eventAction(^ id(NSInteger eventType, id data) {
        @strongify(self);
        [self didSelectedExpressionGroup:data];
        return nil;
    });
    
    // 表情
    self.addSection(IMExpressionMoreSectionTypeExprs).backgrounColor([UIColor whiteColor]).sectionInsets(UIEdgeInsetsMake(15, 15, 0, 15)).minimumInteritemSpacing(15);
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if (!CGRectEqualToRect(self.collectionView.frame, self.view.bounds)) {
        [self.collectionView setFrame:self.view.bounds];
        self.updateCells.all();
        [self.collectionView reloadData];
    }
}

- (void)requestDataIfNeed
{
    if ([self dataModelArrayForSection:IMExpressionMoreSectionTypeExprs].count == 0) {
        [IMUIUtility showLoading:nil];
        [self requestExpressionMoreDataWithPageIndex:1];
    }
}

#pragma mark - # Event Action
- (void)didSelectedExpressionGroup:(IMExpressionGroupModel *)groupModel
{
    IMExpressionDetailViewController *detailVC = [[IMExpressionDetailViewController alloc] initWithGroupModel:groupModel];
    IMPushVC(detailVC);
}

#pragma mark - # Request
- (void)requestExpressionMoreDataWithPageIndex:(NSInteger)pageIndex
{
    if (pageIndex == 1) {
        [self.collectionView tt_removeLoadMoreFooter];
    }
    self.pageIndex = pageIndex;
    [self removeTipView];
    @weakify(self);
    [IMExpressionGroupModel requestExpressionMoreListByPageIndex:pageIndex success:^(NSArray *successData) {
        @strongify(self);
        [IMUIUtility hiddenLoading];
        if (pageIndex == 1) {
            [self deleteAllItemsForSection:IMExpressionMoreSectionTypeExprs];
        }
        if (successData.count > 0) {
            if (pageIndex == 1) {
                [self.collectionView tt_addLoadMoreFooterWithAction:^{
                    @strongify(self);
                    [self requestExpressionMoreDataWithPageIndex:self.pageIndex + 1];
                }];
            }
            self.addCells(@"IMExpressionMoreCell").withDataModelArray(successData).toSection(IMExpressionMoreSectionTypeExprs).selectedAction(^ (id data) {
                @strongify(self);
                [self didSelectedExpressionGroup:data];
            });
            [self.collectionView tt_endLoadMore];
        }
        else {
            [self.collectionView tt_showNoMoreFooter];
        }
        [self reloadView];
    } failure:^(id failureData) {
        @strongify(self);
        [IMUIUtility hiddenLoading];
        [self.collectionView tt_endLoadMore];
        [self.view showErrorViewWithTitle:failureData retryAction:^(id userData) {
            @strongify(self);
            [self requestDataIfNeed];
        }];
    }];
}


@end
