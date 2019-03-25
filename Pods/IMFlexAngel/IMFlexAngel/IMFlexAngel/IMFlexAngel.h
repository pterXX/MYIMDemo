//
//  IMFlexAngel.h
//  IMFlexDemo
//
//  Created by 徐世杰 on 2017/12/14.
//  Copyright © 2017年 徐世杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMFlexibleLayoutSectionModel.h"
#import "IMFlexChainSectionModel.h"
#import "IMFlexChainViewModel.h"
#import "IMFlexChainViewBatchModel.h"
#import "IMFlexChainViewEditModel.h"
#import "IMFlexibleLayoutViewProtocol.h"
#import "IMFlexMacros.h"

#define     IMFLEX_CHAINAPI_TYPE            @property (nonatomic, copy, readonly)

@interface IMFlexAngel : NSObject

/// 数据源
@property (nonatomic, strong) NSMutableArray *data;

/// 宿主，可以是tableView或者collectionView
@property (nonatomic, weak, readonly) __kindof UIScrollView *hostView;

/**
 *  根据宿主View初始化
 */
- (instancetype)initWithHostView:(__kindof UIScrollView *)hostView;
- (instancetype)init NS_UNAVAILABLE;

@end

#pragma mark - ## IMFlexAngel (API)
@interface IMFlexAngel (API)

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

/// 获取/编辑section （可清空、获取数据源等）
IMFLEX_CHAINAPI_TYPE IMFlexChainSectionEditModel *(^sectionForTag)(NSInteger tag);

/// 删除section
IMFLEX_CHAINAPI_TYPE BOOL (^deleteSection)(NSInteger tag);

/// 判断section是否存在
IMFLEX_CHAINAPI_TYPE BOOL (^hasSection)(NSInteger tag);


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
/// 添加空白cell
IMFLEX_CHAINAPI_TYPE IMFlexChainViewModel *(^ addSeperatorCell)(CGSize size, UIColor *color);


/// 插入cell
IMFLEX_CHAINAPI_TYPE IMFlexChainViewInsertModel *(^ insertCell)(NSString *className);
/// 批量插入cell
IMFLEX_CHAINAPI_TYPE IMFlexChainViewBatchInsertModel *(^ insertCells)(NSString *className);


/// 删除符合条件的cell
IMFLEX_CHAINAPI_TYPE IMFlexChainViewEditModel *deleteCell;
/// 删除所有符合条件的cell
IMFLEX_CHAINAPI_TYPE IMFlexChainViewBatchEditModel *deleteCells;


/// 更新符合条件的cell高度
IMFLEX_CHAINAPI_TYPE IMFlexChainViewEditModel *updateCell;
/// 更新所有符合条件的cell高度
IMFLEX_CHAINAPI_TYPE IMFlexChainViewBatchEditModel *updateCells;


/// 是否包含cell
IMFLEX_CHAINAPI_TYPE IMFlexChainViewEditModel *hasCell;


/// cell数据源获取
IMFLEX_CHAINAPI_TYPE IMFlexChainViewEditModel *dataModel;
/// 批量cell数据源获取(注意，dataModel为nil的元素，在数组中以NSNull存在)
IMFLEX_CHAINAPI_TYPE IMFlexChainViewBatchEditModel *dataModelArray;

@end
