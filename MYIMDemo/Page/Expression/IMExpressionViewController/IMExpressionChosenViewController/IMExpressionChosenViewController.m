//
//  IMExpressionChosenViewController.m
//  IMChat
//
//  Created by 李伯坤 on 16/4/4.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "IMExpressionChosenViewController.h"
#import "IMExpressionSearchResultViewController.h"
#import "IMSearchController.h"
#import "IMExpressionGroupModel+ChosenRequest.h"
#import "IMExpressionHelper.h"
#import "IMExpressionChosenAngel.h"
#import "IMExpressionDetailViewController.h"

typedef NS_ENUM(NSInteger, IMExpressionChosenSectionType) {
    IMExpressionChosenSectionTypeBanner,
    IMExpressionChosenSectionTypeRec,
    IMExpressionChosenSectionTypeChosen,
};

@interface IMExpressionChosenViewController () <UISearchBarDelegate>

@property (nonatomic, assign) NSInteger pageIndex;

/// 列表
@property (nonatomic, strong) UITableView *tableView;
/// 列表管理器
@property (nonatomic, strong) IMExpressionChosenAngel *tableViewAngel;
/// 请求队列
@property (nonatomic, strong) IMFLEXRequestQueue *requestQueue;
/// 搜索
@property (nonatomic, strong) IMSearchController *searchController;

@end

@implementation IMExpressionChosenViewController

- (void)loadView
{
    [super loadView];
    
    [self p_loadUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 更新表情状态
    [self.tableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [IMUIUtility hiddenLoading];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if (!CGRectEqualToRect(self.view.bounds, self.tableView.frame)) {
        [self.tableView setFrame:self.view.bounds];
        self.tableViewAngel.updateCells.all();
        [self.tableView reloadData];
    }
}

#pragma mark - # Requests
- (void)requestDataIfNeed
{
    if (self.tableViewAngel.sectionForTag(IMExpressionChosenSectionTypeChosen).dataModelArray.count > 0) {
        return;
    }
    if (self.requestQueue.isRuning) {
        return;
    }
    self.requestQueue = [[IMFLEXRequestQueue alloc] init];
    [self.requestQueue addRequestModel:self.bannerRequestModel];
    [self.requestQueue addRequestModel:self.recommentRequestModel];
    [self.requestQueue addRequestModel:[self listRequestModelWithPageIndex:1]];
    [IMUIUtility showLoading:nil];
    [self.requestQueue runAllRequestsWithCompleteAction:^(NSArray *data, NSInteger successCount, NSInteger failureCount) {
        [IMUIUtility hiddenLoading];
    }];
}

#pragma mark - # Event Action
- (void)didSelectedExpressionGroup:(IMExpressionGroupModel *)groupModel
{
    IMExpressionDetailViewController *detailVC = [[IMExpressionDetailViewController alloc] initWithGroupModel:groupModel];
    IMPushVC(detailVC);
}

#pragma mark - # Private Methods
- (void)p_loadUI
{
    /// 初始化列表
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.IM_make.backgroundColor([UIColor whiteColor])
    .separatorStyle(UITableViewCellSeparatorStyleNone)
    .tableHeaderView(self.searchController.searchBar)
    .tableFooterView([UIView new])
    .estimatedRowHeight(0).estimatedSectionFooterHeight(0).estimatedSectionHeaderHeight(0);
    [self.view addSubview:self.tableView];
    
    /// 初始化列表管理器
    self.tableViewAngel = [[IMExpressionChosenAngel alloc] initWithHostView:self.tableView];
    
    /// 初始化基本模块
    self.tableViewAngel.addSection(IMExpressionChosenSectionTypeBanner);
    self.tableViewAngel.addSection(IMExpressionChosenSectionTypeRec);
    self.tableViewAngel.addSection(IMExpressionChosenSectionTypeChosen);
}

#pragma mark - # Getter
- (IMSearchController *)searchController
{
    if (!_searchController) {
        @weakify(self);
        IMExpressionSearchResultViewController *searchResultVC = [[IMExpressionSearchResultViewController alloc] init];
        [searchResultVC setItemClickAction:^(IMExpressionSearchResultViewController *searchController, id data) {
            @strongify(self);
            [self.searchController setActive:NO];
            [self didSelectedExpressionGroup:data];
        }];
        _searchController = [IMSearchController createWithResultsContrller:searchResultVC];
        [_searchController.searchBar setPlaceholder:@"搜索表情"];
    }
    return _searchController;
}

- (IMFLEXRequestModel *)bannerRequestModel
{
    @weakify(self);
    IMFLEXRequestModel *requestModel = [IMFLEXRequestModel requestModelWithTag:IMExpressionChosenSectionTypeBanner requestAction:^(IMFLEXRequestModel *requestModel) {
        [IMExpressionGroupModel requestExpressionChosenBannerSuccess:^(id successData) {
            [requestModel executeRequestCompleteMethodWithSuccess:YES data:successData];
        } failure:^(id failureData) {
            [requestModel executeRequestCompleteMethodWithSuccess:NO data:failureData];
        }];
    } requestCompleteAction:^(IMFLEXRequestModel *requestModel) {
        @strongify(self);
        if (!self) return;
        self.tableViewAngel.sectionForTag(IMExpressionChosenSectionTypeBanner).clear();
        if (requestModel.success) {
            self.tableViewAngel.addCell(@"IMExpressionBannerCell").toSection(requestModel.tag).withDataModel(requestModel.data).eventAction(^id (NSInteger eventType, id data) {
                @strongify(self);
                [self didSelectedExpressionGroup:data];
                return nil;
            });
        }
        else {
            [IMUIUtility showErrorHint:requestModel.data];
        }
        [self.tableView reloadData];
    }];
    return requestModel;
}

- (IMFLEXRequestModel *)recommentRequestModel
{
    @weakify(self);
    IMFLEXRequestModel *requestModel = [IMFLEXRequestModel requestModelWithTag:IMExpressionChosenSectionTypeRec requestAction:^(IMFLEXRequestModel *requestModel) {
        [IMExpressionGroupModel requestExpressionRecommentListSuccess:^(id successData) {
            [requestModel executeRequestCompleteMethodWithSuccess:YES data:successData];
        } failure:^(id failureData) {
            [requestModel executeRequestCompleteMethodWithSuccess:NO data:failureData];
        }];
    } requestCompleteAction:^(IMFLEXRequestModel *requestModel) {
        @strongify(self);
        if (!self) return;
        self.tableViewAngel.sectionForTag(requestModel.tag).clear();
        if (requestModel.success) {
            self.tableViewAngel.setHeader(@"IMExpressionTitleView").withDataModel(@"推荐表情").toSection(requestModel.tag);
            [[IMExpressionHelper sharedHelper] updateExpressionGroupModelsStatus:requestModel.data];
            self.tableViewAngel.addCells(@"IMExpressionItemCell").withDataModelArray(requestModel.data).toSection(requestModel.tag).selectedAction(^ (id data) {
                @strongify(self);
                [self didSelectedExpressionGroup:data];
            });
        }
        [self.tableView reloadData];
    }];
    return requestModel;
}

- (IMFLEXRequestModel *)listRequestModelWithPageIndex:(NSInteger)pageIndex
{
    self.pageIndex = pageIndex;
    @weakify(self);
    IMFLEXRequestModel *requestModel = [IMFLEXRequestModel requestModelWithTag:IMExpressionChosenSectionTypeChosen requestAction:^(IMFLEXRequestModel *requestModel) {
        @strongify(self);
        if (!self) return;
        [IMExpressionGroupModel requestExpressionChosenListByPageIndex:pageIndex success:^(id successData) {
            [requestModel executeRequestCompleteMethodWithSuccess:YES data:successData];
        } failure:^(id failureData) {
            [requestModel executeRequestCompleteMethodWithSuccess:NO data:failureData];
        }];
    } requestCompleteAction:^(IMFLEXRequestModel *requestModel) {
        @strongify(self);
        if (!self) return;
        if (pageIndex == 1) {
            
        }
        if (requestModel.success) {
            if (pageIndex == 1) {
                self.tableViewAngel.sectionForTag(requestModel.tag).clear();
                if ([requestModel.data count] > 0) {
                    self.tableViewAngel.setHeader(@"IMExpressionTitleView").withDataModel(@"更多精选").toSection(requestModel.tag);
                }
                
                [self.tableView tt_addLoadMoreFooterWithAction:^{
                    @strongify(self);
                    [[self listRequestModelWithPageIndex:self.pageIndex + 1] executeRequestMethod];
                }];
            }
            
            if ([requestModel.data count] > 0) {
                [[IMExpressionHelper sharedHelper] updateExpressionGroupModelsStatus:requestModel.data];
                self.tableViewAngel.addCells(@"IMExpressionItemCell").withDataModelArray(requestModel.data).toSection(requestModel.tag).selectedAction(^ (id data) {
                    @strongify(self);
                    [self didSelectedExpressionGroup:data];
                });
                [self.tableView tt_endLoadMore];
            }
            else {
                [self.tableView tt_showNoMoreFooter];
            }
        }
        else {
            if (pageIndex == 1) {
                [self.view showErrorViewWithTitle:requestModel.data retryAction:^(id userData) {
                    @weakify(self);
                    [self requestDataIfNeed];
                }];
            }
            else {
                [self.tableView tt_showNoMoreFooter];
            }
        }
        [self.tableView reloadData];
    }];
    return requestModel;
}

@end
