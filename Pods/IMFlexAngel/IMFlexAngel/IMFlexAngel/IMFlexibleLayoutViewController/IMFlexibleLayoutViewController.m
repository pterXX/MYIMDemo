//
//  IMFlexibleLayoutViewController.m
//  zhuanzhuan
//
//  Created by 李伯坤 on 2016/10/10.
//  Copyright © 2016年 wuba. All rights reserved.
//

#import "IMFlexibleLayoutViewController.h"
#import "IMFlexibleLayoutViewController+Kernel.h"
#import "IMFlexibleLayoutViewController+OldAPI.h"
#import "IMFlexibleLayoutSectionModel.h"
#import "IMFlexibleLayoutViewProtocol.h"
#import "IMFlexibleLayoutSeperatorCell.h"
#import "IMFLEXMacros.h"

@implementation IMFlexibleLayoutViewController

- (id)init
{
    if (self = [super init]) {
        _data = [[NSMutableArray alloc] init];
        _scrollDirection = UICollectionViewScrollDirectionVertical;
        
        IMFlexibleLayoutFlowLayout *layout = [[IMFlexibleLayoutFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [self.collectionView setBackgroundColor:[UIColor clearColor]];
        [self.collectionView setDataSource:self];
        [self.collectionView setDelegate:self];
        [self.collectionView setShowsHorizontalScrollIndicator:NO];
        [self.collectionView setAlwaysBounceVertical:YES];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    [self.view addSubview:self.collectionView];
    RegisterCollectionViewCell(self.collectionView, CELL_SEPEARTOR);        // 注册空白cell
    RegisterCollectionViewReusableView(self.collectionView, UICollectionElementKindSectionHeader, @"IMFlexibleLayoutEmptyHeaderFooterView");
    RegisterCollectionViewReusableView(self.collectionView, UICollectionElementKindSectionFooter, @"IMFlexibleLayoutEmptyHeaderFooterView");
}

- (void)dealloc
{
    IMFLEXLog(@"Dealloc: %@", NSStringFromClass([self class]));
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if (!CGRectEqualToRect(self.view.bounds, self.collectionView.frame)) {
        [self.collectionView setFrame:self.view.bounds];
        self.updateCells.all();
        [self reloadView];
    }
}

#pragma mark - # API
- (void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection
{
    _scrollDirection = scrollDirection;
    [(IMFlexibleLayoutFlowLayout *)self.collectionView.collectionViewLayout setScrollDirection:scrollDirection];
}

#pragma mark 页面刷新
/// 刷新页面
- (void)reloadView
{
    [UIView performWithoutAnimation:^{
        [self.collectionView reloadData];
    }];
}

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

- (NSInteger)sectionIndexForTag:(NSInteger)sectionTag
{
    for (int section = 0; section < self.data.count; section++) {
        IMFlexibleLayoutSectionModel *sectionModel = self.data[section];
        if (sectionModel.sectionTag == sectionTag) {
            return section;
        }
    }
    return 0;
}

- (BOOL)deleteAllItemsForSection:(NSInteger)tag
{
    IMFlexibleLayoutSectionModel *sectionModel = [self sectionModelForTag:tag];
    if (sectionModel) {
        sectionModel.headerViewModel = nil;
        sectionModel.footerViewModel = nil;
        [sectionModel.itemsArray removeAllObjects];
        return YES;
    }
    return NO;
}

- (BOOL)deleteAllCellsForSection:(NSInteger)tag {
    IMFlexibleLayoutSectionModel *sectionModel = [self sectionModelForTag:tag];
    if (sectionModel) {
        [sectionModel.itemsArray removeAllObjects];
        return YES;
    }
    return NO;
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
        RegisterCollectionViewReusableView(self.collectionView, UICollectionElementKindSectionHeader, className);
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
        RegisterCollectionViewReusableView(self.collectionView, UICollectionElementKindSectionFooter, className);
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
        RegisterCollectionViewCell(self.collectionView, className);
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
        RegisterCollectionViewCell(self.collectionView, className);
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
        viewModel.className = CELL_SEPEARTOR;
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
        RegisterCollectionViewCell(self.collectionView, className);
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
        RegisterCollectionViewCell(self.collectionView, className);
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

#pragma mark - ## IMFlexibleLayoutViewController (View)
@implementation IMFlexibleLayoutViewController (View)
- (void)scrollToTop:(BOOL)animated
{
    [self.collectionView setContentOffset:CGPointZero animated:animated];
}

- (void)scrollToBottom:(BOOL)animated
{
    CGFloat y = self.collectionView.contentSize.height - self.collectionView.frame.size.height;
    [self.collectionView setContentOffset:CGPointMake(0, y) animated:animated];
}

- (void)scrollToSection:(NSInteger)sectionTag position:(UICollectionViewScrollPosition)scrollPosition animated:(BOOL)animated
{
    if (self.hasSection(sectionTag)) {
        NSInteger section = [self sectionIndexForTag:sectionTag];
        NSUInteger sectionCount = [self.collectionView numberOfSections];
        if (sectionCount > section) {
            NSUInteger itemCount = [self.collectionView numberOfItemsInSection:section];
            if (itemCount > 0) {
                NSInteger index = 0;
                if (scrollPosition == UICollectionViewScrollPositionBottom || scrollPosition == UICollectionViewScrollPositionRight) {
                    scrollPosition = itemCount - 1;
                }
                else if (scrollPosition == UICollectionViewScrollPositionCenteredVertically || scrollPosition == UICollectionViewScrollPositionCenteredHorizontally) {
                    scrollPosition = itemCount / 2.0;
                }
                
                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:section] atScrollPosition:scrollPosition animated:animated];
            }
        }
    }
}

- (void)scrollToSection:(NSInteger)sectionTag cell:(NSInteger)cellTag position:(UICollectionViewScrollPosition)scrollPosition animated:(BOOL)animated
{
    NSArray *indexPaths = [self cellIndexPathForSectionTag:sectionTag cellTag:cellTag];
    if (indexPaths.count > 0) {
        NSIndexPath *indexPath = indexPaths[0];
        [self scrollToIndexPath:indexPath position:scrollPosition animated:animated];
    }
}

- (void)scrollToCell:(NSInteger)cellTag position:(UICollectionViewScrollPosition)scrollPosition animated:(BOOL)animated
{
    NSArray *indexPaths = [self cellIndexPathForCellTag:cellTag];
    if (indexPaths.count > 0) {
        NSIndexPath *indexPath = indexPaths[0];
        [self scrollToIndexPath:indexPath position:scrollPosition animated:animated];
    }
}

- (void)scrollToSectionIndex:(NSInteger)sectionIndex position:(UICollectionViewScrollPosition)scrollPosition animated:(BOOL)animated
{
    if (sectionIndex < self.data.count) {
        [self scrollToIndexPath:[NSIndexPath indexPathForItem:0 inSection:sectionIndex] position:scrollPosition animated:animated];
    }
}

- (void)scrollToIndexPath:(NSIndexPath *)indexPath position:(UICollectionViewScrollPosition)scrollPosition animated:(BOOL)animated
{
    if (self.hasCell.atIndexPath(indexPath)) {
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
    }
}

@end
