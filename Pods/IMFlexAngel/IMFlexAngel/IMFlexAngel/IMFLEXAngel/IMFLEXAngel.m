
//
//  IMFLEXAngel.m
//  IMFLEXDemo
//
//  Created by 李伯坤 on 2017/12/14.
//  Copyright © 2017年 李伯坤. All rights reserved.
//

#import "IMFLEXAngel.h"
#import "IMFLEXAngel+Private.h"
#import "IMFLEXAngel+UITableView.h"
#import "IMFLEXAngel+UICollectionView.h"
#import "IMFlexibleLayoutSeperatorCell.h"
#import "IMFLEXTableViewEmptyCell.h"
#import "IMFLEXMacros.h"

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

@implementation IMFLEXAngel

- (instancetype)initWithHostView:(__kindof UIScrollView *)hostView
{
    if (self = [super init]) {
        _hostView = hostView;
        _data = [[NSMutableArray alloc] init];
        if ([_hostView isKindOfClass:[UITableView class]]) {
            [(UITableView *)_hostView setDataSource:self];
            [(UITableView *)_hostView setDelegate:self];
            RegisterHostViewCell(_hostView, @"IMFLEXTableViewEmptyCell");
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


#pragma mark - ## IMFLEXAngel (API)
@implementation IMFLEXAngel (API)

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
- (IMFLEXChainSectionModel *(^)(NSInteger tag))addSection
{
    @weakify(self);
    return ^(NSInteger tag){
        @strongify(self);
        if (self.hasSection(tag)) {
            IMFLEXLog(@"!!!!! 重复添加Section：%ld", (long)tag);
        }
        
        IMFlexibleLayoutSectionModel *sectionModel = [[IMFlexibleLayoutSectionModel alloc] init];
        sectionModel.sectionTag = tag;
        
        [self.data addObject:sectionModel];
        IMFLEXChainSectionModel *chainSectionModel = [[IMFLEXChainSectionModel alloc] initWithSectionModel:sectionModel];
        return chainSectionModel;
    };
}

- (IMFLEXChainSectionInsertModel *(^)(NSInteger tag))insertSection
{
    @weakify(self);
    return ^(NSInteger tag){
        @strongify(self);
        if (self.hasSection(tag)) {
            IMFLEXLog(@"!!!!! 重复添加Section：%ld", (long)tag);
        }
        
        IMFlexibleLayoutSectionModel *sectionModel = [[IMFlexibleLayoutSectionModel alloc] init];
        sectionModel.sectionTag = tag;
        
        IMFLEXChainSectionInsertModel *chainSectionModel = [[IMFLEXChainSectionInsertModel alloc] initWithSectionModel:sectionModel listData:self.data];
        return chainSectionModel;
    };
}

/// 获取section
- (IMFLEXChainSectionEditModel *(^)(NSInteger tag))sectionForTag
{
    @weakify(self);
    return ^(NSInteger tag){
        @strongify(self);
        IMFlexibleLayoutSectionModel *sectionModel = nil;
        for (sectionModel in self.data) {
            if (sectionModel.sectionTag == tag) {
                IMFLEXChainSectionEditModel *chainSectionModel = [[IMFLEXChainSectionEditModel alloc] initWithSectionModel:sectionModel];
                return chainSectionModel;
            }
        }
        return [[IMFLEXChainSectionEditModel alloc] initWithSectionModel:nil];
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
- (IMFLEXChainViewModel *(^)(NSString *className))setHeader
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
        IMFLEXChainViewModel *chainViewModel = [[IMFLEXChainViewModel alloc] initWithListData:self.data viewModel:viewModel andType:IMFLEXChainViewTypeHeader];
        return chainViewModel;
    };
}

//MARK: Footer
- (IMFLEXChainViewModel *(^)(NSString *className))setFooter
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
        IMFLEXChainViewModel *chainViewModel = [[IMFLEXChainViewModel alloc] initWithListData:self.data viewModel:viewModel andType:IMFLEXChainViewTypeFooter];
        return chainViewModel;
    };
}

#pragma mark - # Cell 操作
/// 添加cell
- (IMFLEXChainViewModel *(^)(NSString *className))addCell
{
    @weakify(self);
    return ^(NSString *className) {
        @strongify(self);
        RegisterHostViewCell(self.hostView, className);
        IMFlexibleLayoutViewModel *viewModel = [[IMFlexibleLayoutViewModel alloc] init];
        viewModel.className = className;
        IMFLEXChainViewModel *chainViewModel = [[IMFLEXChainViewModel alloc] initWithListData:self.data viewModel:viewModel andType:IMFLEXChainViewTypeCell];
        return chainViewModel;
    };
}

/// 批量添加cell
- (IMFLEXChainViewBatchModel *(^)(NSString *className))addCells
{
    @weakify(self);
    return ^(NSString *className) {
        @strongify(self);
        RegisterHostViewCell(self.hostView, className);
        IMFLEXChainViewBatchModel *viewModel = [[IMFLEXChainViewBatchModel alloc] initWithClassName:className listData:self.data];
        return viewModel;
    };
}

/// 添加空白cell
- (IMFLEXChainViewModel *(^)(CGSize size, UIColor *color))addSeperatorCell;
{
    @weakify(self);
    return ^(CGSize size, UIColor *color) {
        @strongify(self);
        IMFlexibleLayoutViewModel *viewModel = [[IMFlexibleLayoutViewModel alloc] init];
        viewModel.className = [self.hostView isKindOfClass:[UITableView class]] ? NSStringFromClass([IMFLEXTableViewEmptyCell class]) : NSStringFromClass([IMFlexibleLayoutSeperatorCell class]);
        viewModel.dataModel = [[IMFlexibleLayoutSeperatorModel alloc] initWithSize:size andColor:color];
        IMFLEXChainViewModel *chainViewModel = [[IMFLEXChainViewModel alloc] initWithListData:self.data viewModel:viewModel andType:IMFLEXChainViewTypeCell];
        return chainViewModel;
    };
}

/// 插入cell
- (IMFLEXChainViewInsertModel *(^)(NSString *className))insertCell
{
    @weakify(self);
    return ^(NSString *className) {
        @strongify(self);
        RegisterHostViewCell(self.hostView, className);
        IMFlexibleLayoutViewModel *viewModel = [[IMFlexibleLayoutViewModel alloc] init];
        viewModel.className = className;
        IMFLEXChainViewInsertModel *chainViewModel = [[IMFLEXChainViewInsertModel alloc] initWithListData:self.data viewModel:viewModel andType:IMFLEXChainViewTypeCell];
        return chainViewModel;
    };
}

/// 批量插入cells
- (IMFLEXChainViewBatchInsertModel *(^)(NSString *className))insertCells
{
    @weakify(self);
    return ^(NSString *className) {
        @strongify(self);
        RegisterHostViewCell(self.hostView, className);
        IMFLEXChainViewBatchInsertModel *viewModel = [[IMFLEXChainViewBatchInsertModel alloc] initWithClassName:className listData:self.data];
        return viewModel;
    };
}

/// 删除cell
- (IMFLEXChainViewEditModel *)deleteCell
{
    IMFLEXChainViewEditModel *deleteModel = [[IMFLEXChainViewEditModel alloc] initWithType:IMFLEXChainViewEditTypeDelete andListData:self.data];
    return deleteModel;
}

/// 批量删除cell
- (IMFLEXChainViewBatchEditModel *)deleteCells
{
    IMFLEXChainViewBatchEditModel *deleteModel = [[IMFLEXChainViewBatchEditModel alloc] initWithType:IMFLEXChainViewEditTypeDelete andListData:self.data];
    return deleteModel;
}

/// 更新cell
- (IMFLEXChainViewEditModel *)updateCell
{
    IMFLEXChainViewEditModel *deleteModel = [[IMFLEXChainViewEditModel alloc] initWithType:IMFLEXChainViewEditTypeUpdate andListData:self.data];
    return deleteModel;
}

/// 批量更新cell
- (IMFLEXChainViewBatchEditModel *)updateCells
{
    IMFLEXChainViewBatchEditModel *deleteModel = [[IMFLEXChainViewBatchEditModel alloc] initWithType:IMFLEXChainViewEditTypeUpdate andListData:self.data];
    return deleteModel;
}

/// 包含cell
- (IMFLEXChainViewEditModel *)hasCell
{
    IMFLEXChainViewEditModel *deleteModel = [[IMFLEXChainViewEditModel alloc] initWithType:IMFLEXChainViewEditTypeHas andListData:self.data];
    return deleteModel;
}

#pragma mark - # DataModel 数据源获取
/// 数据源获取
- (IMFLEXChainViewEditModel *)dataModel
{
    IMFLEXChainViewEditModel *dataModel = [[IMFLEXChainViewEditModel alloc] initWithType:IMFLEXChainViewEditTypeDataModel andListData:self.data];
    return dataModel;
}

/// 批量获取数据源
- (IMFLEXChainViewBatchEditModel *)dataModelArray
{
    IMFLEXChainViewBatchEditModel *dataModel = [[IMFLEXChainViewBatchEditModel alloc] initWithType:IMFLEXChainViewEditTypeDataModel andListData:self.data];
    return dataModel;
}

@end
