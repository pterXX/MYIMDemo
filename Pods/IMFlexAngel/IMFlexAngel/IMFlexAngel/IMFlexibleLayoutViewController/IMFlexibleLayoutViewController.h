//
//  IMFlexibleLayoutViewController.h
//  MYIMDemo
//
//  Created by admin on 2019/3/18.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "IMFlexChainSectionModel.h"
#import "IMFlexChainViewModel.h"
#import "IMFlexChainViewBatchModel.h"
#import "IMFlexChainViewEditModel.h"

NS_ASSUME_NONNULL_BEGIN

#define     TAG_CELL_NONE                   0                                               // 默认cell Tag，在未指定时使用
#define     TAG_CELL_SEPERATOR              -1                                              // 空白分割cell Tag
#define     DEFAULT_SEPERATOR_SIZE          CGSizeMake(self.view.frame.size.width, 10.0f)   // 默认分割cell大小
#define     DEFAULT_SEPERATOR_COLOR         [UIColor clearColor]                            // 默认分割cell颜色

#define     IMFLEX_CHAINAPI_TYPE            @property (nonatomic, copy, readonly)

#pragma mark - ## IMFlexibleLayoutViewControllerProtocol
@protocol IMFlexibleLayoutViewControllerProtocol <NSObject>
@optional;
/**
 *  collectionView Cell 点击事件
 */
- (void)collectionViewDidSelectItem:(id)itemModel
                         sectionTag:(NSInteger)sectionTag
                            cellTag:(NSInteger)cellTag
                          className:(NSString *)className
                          indexPath:(NSIndexPath *)indexPath;
@end


#pragma mark - ## IMFlexibleLayoutViewController
@class IMFlexibleLayoutSectionModel;
@interface IMFlexibleLayoutViewController : UIViewController<
IMFlexibleLayoutViewControllerProtocol
>

/// 瀑布流列表
@property (nonatomic, strong, readonly) UICollectionView *collectionView;

/// 数据源
@property (nonatomic, strong, readonly) NSMutableArray *data;


/// 滚动方向，默认垂直
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;

/// header悬浮，默认NO
@property (nonatomic, assign) BOOL sectionHeadersPinToVisibleBounds;
/// footer悬浮，默认NO
@property (nonatomic, assign) BOOL sectionFootersPinToVisibleBounds;

@end


#pragma mark - ## IMFlexibleLayoutViewController (API)
@interface IMFlexibleLayoutViewController (API)

#pragma mark - # 页面
/// 刷新页面
- (void)reloadView;


#pragma mark - # 整体
/// 删除所有元素
IMFLEX_CHAINAPI_TYPE BOOL (^clear)(void);

/// 删除所有Cell
IMFLEX_CHAINAPI_TYPE BOOL (^clearAllCells)(void);

/// 更新所有元素
IMFLEX_CHAINAPI_TYPE BOOL (^upadte)(void);

/// 更新所有Cell
IMFLEX_CHAINAPI_TYPE BOOL (^upadteAllCells)(void);

#pragma mark - # Section操作
/// 添加section
IMFLEX_CHAINAPI_TYPE IMFlexChainSectionModel *(^addSection)(NSInteger tag);

/// 插入section
IMFLEX_CHAINAPI_TYPE IMFlexChainSectionInsertModel *(^insertSection)(NSInteger tag);

/// 获取/编辑section
IMFLEX_CHAINAPI_TYPE IMFlexChainSectionEditModel *(^sectionForTag)(NSInteger tag);

/// 删除section
IMFLEX_CHAINAPI_TYPE BOOL (^deleteSection)(NSInteger tag);

/// 判断section是否存在
IMFLEX_CHAINAPI_TYPE BOOL (^hasSection)(NSInteger tag);

/// 删除section的所有元素（cell,header,footer），或使用 self.sectionFotTag(tag).clear();
- (BOOL)deleteAllItemsForSection:(NSInteger)tag;

/// 删除section的所有cell, 或使用 self.sectionFotTag(tag).clearAllCells()
- (BOOL)deleteAllCellsForSection:(NSInteger)tag;

/// 更新section信息，或使用 self.sectionFotTag(tag).update()
- (void)updateSectionForTag:(NSInteger)sectionTag;

/// 获取section index
- (NSInteger)sectionIndexForTag:(NSInteger)sectionTag;


#pragma mark - # Section HeaderFooter 操作
/// 为section添加headerView，传入nil将删除header
IMFLEX_CHAINAPI_TYPE IMFlexChainViewModel *(^setHeader)(NSString *className);

/// 为section添加footerView，传入nil将删除footer
IMFLEX_CHAINAPI_TYPE IMFlexChainViewModel *(^setFooter)(NSString *className);


#pragma mark - # Section Cell 操作
/// 添加cell
IMFLEX_CHAINAPI_TYPE IMFlexChainViewModel *(^ addCell)(NSString *className);

/// 批量添加cell
IMFLEX_CHAINAPI_TYPE IMFlexChainViewBatchModel *(^ addCells)(NSString *className);

/// 插入cell
IMFLEX_CHAINAPI_TYPE IMFlexChainViewInsertModel *(^ insertCell)(NSString *className);

/// 批量插入cell
IMFLEX_CHAINAPI_TYPE IMFlexChainViewBatchInsertModel *(^ insertCells)(NSString *className);

/// 添加空白cell
IMFLEX_CHAINAPI_TYPE IMFlexChainViewModel *(^ addSeperatorCell)(CGSize size, UIColor *color);

/// 删除第一个符合条件的cell
IMFLEX_CHAINAPI_TYPE IMFlexChainViewEditModel *deleteCell;

/// 删除所有符合条件的cell
IMFLEX_CHAINAPI_TYPE IMFlexChainViewBatchEditModel *deleteCells;

/// 更新第一个符合条件的cell高度
IMFLEX_CHAINAPI_TYPE IMFlexChainViewEditModel *updateCell;

/// 更新所有符合条件的cell高度
IMFLEX_CHAINAPI_TYPE IMFlexChainViewBatchEditModel *updateCells;

/// 是否包含cell
IMFLEX_CHAINAPI_TYPE IMFlexChainViewEditModel *hasCell;

#pragma mark - # DataModel 数据源获取
/// 数据源获取
IMFLEX_CHAINAPI_TYPE IMFlexChainViewEditModel *dataModel;
/// 批量数据源获取(注意，dataModel为nil的元素，在数组中以NSNull存在)
IMFLEX_CHAINAPI_TYPE IMFlexChainViewBatchEditModel *dataModelArray;

@end

#pragma mark - ## IMFlexibleLayoutViewController (View)
@interface IMFlexibleLayoutViewController (View)

- (void)scrollToTop:(BOOL)animated;
- (void)scrollToBottom:(BOOL)animated;
- (void)scrollToSection:(NSInteger)sectionTag position:(UICollectionViewScrollPosition)scrollPosition animated:(BOOL)animated;
- (void)scrollToSection:(NSInteger)sectionTag cell:(NSInteger)cellTag position:(UICollectionViewScrollPosition)scrollPosition animated:(BOOL)animated;
- (void)scrollToCell:(NSInteger)cellTag position:(UICollectionViewScrollPosition)scrollPosition animated:(BOOL)animated;
- (void)scrollToSectionIndex:(NSInteger)sectionIndex position:(UICollectionViewScrollPosition)scrollPosition animated:(BOOL)animated;
- (void)scrollToIndexPath:(NSIndexPath *)indexPath position:(UICollectionViewScrollPosition)scrollPosition animated:(BOOL)animated;

@end


NS_ASSUME_NONNULL_END
