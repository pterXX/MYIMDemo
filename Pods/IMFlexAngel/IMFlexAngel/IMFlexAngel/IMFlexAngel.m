
//
//  IMFlexAngel.m
//  IMFlexDemo
//
//  Created by 徐世杰 on 2017/12/14.
//  Copyright © 2017年 徐世杰. All rights reserved.
//

#import "IMFlexAngel.h"
#import "IMFlexAngel+Private.h"
#import "IMFlexAngel+UITableView.h"
#import "IMFlexAngel+UICollectionView.h"
#import "IMFlexibleLayoutSeperatorCell.h"
#import "IMFlexTableViewEmptyCell.h"

/*
 *  注册cells 到 hostView
 */
void RegisterHostViewCell(__kindof UIScrollView *hostView, NSString *cellName)
{
    if ([hostView isKindOfClass:[UITableView class]]) {
        [(UITableView *)hostView registerClass:NSClassFromString(cellName) forCellReuseIdentifier:cellName];
    }
    else if ([hostView isKindOfClass:[UICollectionView class]]) {
        [(UICollectionView *)hostView registerClass:NSClassFromString(cellName) forCellWithReuseIdentifier:cellName];
    }
}

/*
 *  注册ReusableView 到 hostView
 */
void RegisterHostViewReusableView(__kindof UIScrollView *hostView, NSString *kind, NSString *viewName)
{
    if ([hostView isKindOfClass:[UITableView class]]) {
        [(UITableView *)hostView registerClass:NSClassFromString(viewName) forHeaderFooterViewReuseIdentifier:viewName];
    }
    else if ([hostView isKindOfClass:[UICollectionView class]]) {
        [(UICollectionView *)hostView registerClass:NSClassFromString(viewName) forSupplementaryViewOfKind:kind withReuseIdentifier:viewName];
    }
}

@implementation IMFlexAngel

- (instancetype)initWithHostView:(__kindof UIScrollView *)hostView
{
    if (self = [super init]) {
        _hostView = hostView;
        _data = [[NSMutableArray alloc] init];
        if ([_hostView isKindOfClass:[UITableView class]]) {
            [(UITableView *)_hostView setDataSource:self];
            [(UITableView *)_hostView setDelegate:self];
            RegisterHostViewCell(_hostView, @"IMFlexTableViewEmptyCell");
        }
        else if ([_hostView isKindOfClass:[UICollectionView class]]) {
            [(UICollectionView *)_hostView setDataSource:self];
            [(UICollectionView *)_hostView setDelegate:self];
            RegisterHostViewCell(_hostView, @"IMFlexibleLayoutSeperatorCell");        // 注册空白cell
            RegisterHostViewReusableView(_hostView, UICollectionElementKindSectionHeader, @"IMFlexibleLayoutEmptyHeaderFooterView");
            RegisterHostViewReusableView(_hostView, UICollectionElementKindSectionFooter, @"IMFlexibleLayoutEmptyHeaderFooterView");
        }
    }
    return self;
}

@end


#pragma mark - ## IMFlexAngel (API)
@implementation IMFlexAngel (API)

#pragma mark - # 整体
- (BOOL (^)(void))clear
{
    @weakify(self);
    return ^(void) {
        @strongify(self);
        [self.data removeAllObjects];
        return YES;
    };
}

- (BOOL (^)(void))clearAllCells
{
    @weakify(self);
    return ^(void) {
        @strongify(self);
        for (IMFlexibleLayoutSectionModel *sectionModel in self.data) {
            [sectionModel.itemsArray removeAllObjects];
        }
        return YES;
    };
}

/// 更新所有元素
- (BOOL (^)(void))upadte
{
    @weakify(self);
    return ^(void) {
        @strongify(self);
        for (IMFlexibleLayoutSectionModel *sectionModel in self.data) {
            [sectionModel.headerViewModel updateViewHeight];
            [sectionModel.footerViewModel updateViewHeight];
            for (IMFlexibleLayoutViewModel *viewModel in sectionModel.itemsArray) {
                [viewModel updateViewHeight];
            }
        }
        return YES;
    };
}

/// 更新所有Cell
- (BOOL (^)(void))upadteAllCells
{
    @weakify(self);
    return ^(void) {
        @strongify(self);
        for (IMFlexibleLayoutSectionModel *sectionModel in self.data) {
            for (IMFlexibleLayoutViewModel *viewModel in sectionModel.itemsArray) {
                [viewModel updateViewHeight];
            }
        }
        return YES;
    };
}

#pragma mark - # Section操作
/// 添加section
- (IMFlexChainSectionModel *(^)(NSInteger tag))addSection
{
    @weakify(self);
    return ^(NSInteger tag){
        @strongify(self);
        if (self.hasSection(tag)) {
            NSLog(@"!!!!! 重复添加Section：%ld", (long)tag);
        }
        
        IMFlexibleLayoutSectionModel *sectionModel = [[IMFlexibleLayoutSectionModel alloc] init];
        sectionModel.sectionTag = tag;
        
        [self.data addObject:sectionModel];
        IMFlexChainSectionModel *chainSectionModel = [[IMFlexChainSectionModel alloc] initWithSectionModel:sectionModel];
        return chainSectionModel;
    };
}

- (IMFlexChainSectionInsertModel *(^)(NSInteger tag))insertSection
{
    @weakify(self);
    return ^(NSInteger tag){
        @strongify(self);
        if (self.hasSection(tag)) {
            NSLog(@"!!!!! 重复添加Section：%ld", (long)tag);
        }
        
        IMFlexibleLayoutSectionModel *sectionModel = [[IMFlexibleLayoutSectionModel alloc] init];
        sectionModel.sectionTag = tag;
        
        IMFlexChainSectionInsertModel *chainSectionModel = [[IMFlexChainSectionInsertModel alloc] initWithSectionModel:sectionModel listData:self.data];
        return chainSectionModel;
    };
}

/// 获取section
- (IMFlexChainSectionEditModel *(^)(NSInteger tag))sectionForTag
{
    @weakify(self);
    return ^(NSInteger tag){
        @strongify(self);
        IMFlexibleLayoutSectionModel *sectionModel = nil;
        for (sectionModel in self.data) {
            if (sectionModel.sectionTag == tag) {
                IMFlexChainSectionEditModel *chainSectionModel = [[IMFlexChainSectionEditModel alloc] initWithSectionModel:sectionModel];
                return chainSectionModel;
            }
        }
        return [[IMFlexChainSectionEditModel alloc] initWithSectionModel:nil];
    };
}

/// 删除section
- (BOOL (^)(NSInteger tag))deleteSection
{
    @weakify(self);
    return ^(NSInteger tag) {
        @strongify(self);
        IMFlexibleLayoutSectionModel *sectionModel = [self sectionModelForTag:tag];
        if (sectionModel) {
            [self.data removeObject:sectionModel];
            return YES;
        }
        return NO;
    };
}

/// 判断section是否存在
- (BOOL (^)(NSInteger tag))hasSection
{
    @weakify(self);
    return ^(NSInteger tag) {
        @strongify(self);
        BOOL hasSection = [self sectionModelForTag:tag] ? YES : NO;
        return hasSection;
    };
}

#pragma mark - # Section View 操作
//MARK: Header
- (IMFlexChainViewModel *(^)(NSString *className))setHeader
{
    @weakify(self);
    return ^(NSString *className) {
        @strongify(self);
        IMFlexibleLayoutViewModel *viewModel;
        if (className) {
            viewModel = [[IMFlexibleLayoutViewModel alloc] init];
            viewModel.className = className;
        }
        RegisterHostViewReusableView(self.hostView, UICollectionElementKindSectionHeader, className);
        IMFlexChainViewModel *chainViewModel = [[IMFlexChainViewModel alloc] initWithListData:self.data viewModel:viewModel andType:IMFlexChainViewTypeHeader];
        return chainViewModel;
    };
}

//MARK: Footer
- (IMFlexChainViewModel *(^)(NSString *className))setFooter
{
    @weakify(self);
    return ^(NSString *className) {
        @strongify(self);
        IMFlexibleLayoutViewModel *viewModel;
        if (className) {
            viewModel = [[IMFlexibleLayoutViewModel alloc] init];
            viewModel.className = className;
        }
        RegisterHostViewReusableView(self.hostView, UICollectionElementKindSectionFooter, className);
        IMFlexChainViewModel *chainViewModel = [[IMFlexChainViewModel alloc] initWithListData:self.data viewModel:viewModel andType:IMFlexChainViewTypeFooter];
        return chainViewModel;
    };
}

#pragma mark - # Cell 操作
/// 添加cell
- (IMFlexChainViewModel *(^)(NSString *className))addCell
{
    @weakify(self);
    return ^(NSString *className) {
        @strongify(self);
        RegisterHostViewCell(self.hostView, className);
        IMFlexibleLayoutViewModel *viewModel = [[IMFlexibleLayoutViewModel alloc] init];
        viewModel.className = className;
        IMFlexChainViewModel *chainViewModel = [[IMFlexChainViewModel alloc] initWithListData:self.data viewModel:viewModel andType:IMFlexChainViewTypeCell];
        return chainViewModel;
    };
}

/// 批量添加cell
- (IMFlexChainViewBatchModel *(^)(NSString *className))addCells
{
    @weakify(self);
    return ^(NSString *className) {
        @strongify(self);
        RegisterHostViewCell(self.hostView, className);
        IMFlexChainViewBatchModel *viewModel = [[IMFlexChainViewBatchModel alloc] initWithClassName:className listData:self.data];
        return viewModel;
    };
}

/// 添加空白cell
- (IMFlexChainViewModel *(^)(CGSize size, UIColor *color))addSeperatorCell;
{
    @weakify(self);
    return ^(CGSize size, UIColor *color) {
        @strongify(self);
        IMFlexibleLayoutViewModel *viewModel = [[IMFlexibleLayoutViewModel alloc] init];
        viewModel.className = [self.hostView isKindOfClass:[UITableView class]] ? NSStringFromClass([IMFlexTableViewEmptyCell class]) : NSStringFromClass([IMFlexibleLayoutSeperatorCell class]);
        viewModel.dataModel = [[IMFlexibleLayoutSeperatorModel alloc] initWithSize:size andColor:color];
        IMFlexChainViewModel *chainViewModel = [[IMFlexChainViewModel alloc] initWithListData:self.data viewModel:viewModel andType:IMFlexChainViewTypeCell];
        return chainViewModel;
    };
}

/// 插入cell
- (IMFlexChainViewInsertModel *(^)(NSString *className))insertCell
{
    @weakify(self);
    return ^(NSString *className) {
        @strongify(self);
        RegisterHostViewCell(self.hostView, className);
        IMFlexibleLayoutViewModel *viewModel = [[IMFlexibleLayoutViewModel alloc] init];
        viewModel.className = className;
        IMFlexChainViewInsertModel *chainViewModel = [[IMFlexChainViewInsertModel alloc] initWithListData:self.data viewModel:viewModel andType:IMFlexChainViewTypeCell];
        return chainViewModel;
    };
}

/// 批量插入cells
- (IMFlexChainViewBatchInsertModel *(^)(NSString *className))insertCells
{
    @weakify(self);
    return ^(NSString *className) {
        @strongify(self);
        RegisterHostViewCell(self.hostView, className);
        IMFlexChainViewBatchInsertModel *viewModel = [[IMFlexChainViewBatchInsertModel alloc] initWithClassName:className listData:self.data];
        return viewModel;
    };
}

/// 删除cell
- (IMFlexChainViewEditModel *)deleteCell
{
    IMFlexChainViewEditModel *deleteModel = [[IMFlexChainViewEditModel alloc] initWithType:IMFlexChainViewEditTypeDelete andListData:self.data];
    return deleteModel;
}

/// 批量删除cell
- (IMFlexChainViewBatchEditModel *)deleteCells
{
    IMFlexChainViewBatchEditModel *deleteModel = [[IMFlexChainViewBatchEditModel alloc] initWithType:IMFlexChainViewEditTypeDelete andListData:self.data];
    return deleteModel;
}

/// 更新cell
- (IMFlexChainViewEditModel *)updateCell
{
    IMFlexChainViewEditModel *deleteModel = [[IMFlexChainViewEditModel alloc] initWithType:IMFlexChainViewEditTypeUpdate andListData:self.data];
    return deleteModel;
}

/// 批量更新cell
- (IMFlexChainViewBatchEditModel *)updateCells
{
    IMFlexChainViewBatchEditModel *deleteModel = [[IMFlexChainViewBatchEditModel alloc] initWithType:IMFlexChainViewEditTypeUpdate andListData:self.data];
    return deleteModel;
}

/// 包含cell
- (IMFlexChainViewEditModel *)hasCell
{
    IMFlexChainViewEditModel *deleteModel = [[IMFlexChainViewEditModel alloc] initWithType:IMFlexChainViewEditTypeHas andListData:self.data];
    return deleteModel;
}

#pragma mark - # DataModel 数据源获取
/// 数据源获取
- (IMFlexChainViewEditModel *)dataModel
{
    IMFlexChainViewEditModel *dataModel = [[IMFlexChainViewEditModel alloc] initWithType:IMFlexChainViewEditTypeDataModel andListData:self.data];
    return dataModel;
}

/// 批量获取数据源
- (IMFlexChainViewBatchEditModel *)dataModelArray
{
    IMFlexChainViewBatchEditModel *dataModel = [[IMFlexChainViewBatchEditModel alloc] initWithType:IMFlexChainViewEditTypeDataModel andListData:self.data];
    return dataModel;
}

@end
