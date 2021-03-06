//
//  IMExpressionSearchResultViewController.m
//  IMChat
//
//  Created by 徐世杰 on 16/4/4.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "IMExpressionSearchResultViewController.h"
#import "IMExpressionDetailViewController.h"
#import "IMExpressionGroupModel+SearchRequest.h"

#define         HEGIHT_EXPCELL      80

typedef NS_ENUM(NSInteger, IMExpressionSearchVCSectionType) {
    IMExpressionSearchVCSectionTypeItems,
};

@interface IMExpressionSearchResultViewController ()

/// 列表
@property (nonatomic, strong) UITableView *tableView;
/// 列表管理器
@property (nonatomic, strong) IMFLEXAngel *tableViewAngel;

@end

@implementation IMExpressionSearchResultViewController

- (void)loadView
{
    [super loadView];
    [self setStatusBarStyle:UIStatusBarStyleDefault];
    
    self.tableView = self.view.addTableView(1)
    .tableHeaderView([UIView new])
    .separatorStyle(UITableViewCellSeparatorStyleNone)
    .estimatedRowHeight(0).estimatedSectionFooterHeight(0).estimatedSectionHeaderHeight(0)
    .masonry(^ (MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    })
    .view;

    self.tableViewAngel = [[IMFLEXAngel alloc] initWithHostView:self.tableView];
}

#pragma mark - # Request
- (void)requsetSearchExpressionGroupWithKeyword:(NSString *)keyword
{
    [IMUIUtility showLoading:nil];
    @weakify(self);
    [IMExpressionGroupModel requestExpressionSearchByKeyword:keyword success:^(NSArray *data) {
        [IMUIUtility hiddenLoading];
        if (data.count > 0) {
            [self p_reloadViewWithData:data];
        }
        else {
            [self p_reloadViewWithData:nil];
            [self.tableView showEmptyViewWithTitle:@"未搜索到相关表情包"];
        }
    } failure:^(NSString *error) {
        [IMUIUtility showErrorHint:error];
        [self p_reloadViewWithData:nil];
        [self.tableView showErrorViewWithTitle:error retryAction:^(id userData) {
            @strongify(self);
            [self requsetSearchExpressionGroupWithKeyword:keyword];
        }];
    }];
}

#pragma mark - # Delegate
//MARK: UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.tableView removeTipView];
    NSString *keyword = searchBar.text;
    if (keyword.length > 0) {
        [self requsetSearchExpressionGroupWithKeyword:keyword];
    }
}

//MARK: UISearchControllerDelegate
- (void)willPresentSearchController:(UISearchController *)searchController;
{
    [self p_clearView];
}

//MARK: UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *keyword = searchController.searchBar.text;
    if (keyword.length == 0) {
        [self p_clearView];
    }
}

#pragma mark - # Private Methods
- (void)p_clearView
{
    [self.tableView removeTipView];
    self.tableViewAngel.clear();
    self.tableViewAngel.addSection(IMExpressionSearchVCSectionTypeItems);
    [self.tableView reloadData];
}

- (void)p_reloadViewWithData:(NSArray *)data
{
    @weakify(self);
    self.tableViewAngel.sectionForTag(IMExpressionSearchVCSectionTypeItems).clear();
    self.tableViewAngel.addCells(@"IMExpressionItemCell").toSection(IMExpressionSearchVCSectionTypeItems).withDataModelArray(data).selectedAction(^ (IMExpressionGroupModel *model) {
        @strongify(self);
        if (self.itemClickAction) {
            self.itemClickAction(self, model);
        }
    });
    [self.tableView reloadData];
}

@end
