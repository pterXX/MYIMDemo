//
//  IMFlexChainSectionModel.h
//  zhuanzhuan
//
//  Created by 徐世杰 on 2017/8/15.
//  Copyright © 2017年 转转. All rights reserved.
//

/**
 *  向列表中添加Section
 */

#import <UIKit/UIKit.h>
#import "IMFlexMacros.h"
@class IMFlexibleLayoutSectionModel;

#pragma mark - ## IMFlexChainSectionBaseModel (基类)
@interface IMFlexChainSectionBaseModel<IMFlexReturnType> : NSObject

/// 最小行间距
- (IMFlexReturnType (^)(CGFloat minimumLineSpacing))minimumLineSpacing;
/// 最小元素间距
- (IMFlexReturnType (^)(CGFloat minimumInteritemSpacing))minimumInteritemSpacing;
/// sectionInsets
- (IMFlexReturnType (^)(UIEdgeInsets sectionInsets))sectionInsets;
/// backgrounColor
- (IMFlexReturnType (^)(UIColor *backgrounColor))backgrounColor;

/// 初始化，框架内部使用
- (instancetype)initWithSectionModel:(IMFlexibleLayoutSectionModel *)sectionModel;

@end

#pragma mark - ## IMFlexChainSectionModel （添加）
@class IMFlexChainSectionModel;
@interface IMFlexChainSectionModel : IMFlexChainSectionBaseModel <IMFlexChainSectionModel *>

@end

#pragma mark - ## IMFlexChainSectionInsertModel （插入）
@class IMFlexChainSectionInsertModel;
@interface IMFlexChainSectionInsertModel : IMFlexChainSectionBaseModel <IMFlexChainSectionInsertModel *>

/// 插入到指定Index
- (IMFlexChainSectionInsertModel *(^)(NSInteger index))toIndex;

/// 插入到某个section前
- (IMFlexChainSectionInsertModel *(^)(NSInteger sectionTag))beforeSection;

/// 插入到某个section后
- (IMFlexChainSectionInsertModel *(^)(NSInteger sectionTag))afterSection;

/// 框架内部使用
- (instancetype)initWithSectionModel:(IMFlexibleLayoutSectionModel *)sectionModel listData:(NSMutableArray *)listData;

@end

#pragma mark - ## IMFlexChainSectionEditModel （编辑）
@class IMFlexChainSectionEditModel;
@interface IMFlexChainSectionEditModel : IMFlexChainSectionBaseModel <IMFlexChainSectionEditModel *>

#pragma mark 获取数据源
/// 所有cell数据源
@property (nonatomic, strong, readonly) NSArray *dataModelArray;
/// header数据源
@property (nonatomic, strong, readonly) id dataModelForHeader;
/// footer数据源
@property (nonatomic, strong, readonly) id dataModelForFooter;

/// 根据viewTag获取数据源
- (id (^)(NSInteger viewTag))dataModelByViewTag;
/// 根据viewTag批量获取数据源
- (NSArray *(^)(NSInteger viewTag))dataModelArrayByViewTag;

#pragma mark 删除
/// 清空所有视图和cell
- (IMFlexChainSectionEditModel *(^)(void))clear;
/// 清空所有cell
- (IMFlexChainSectionEditModel *(^)(void))clearCells;

/// 删除SectionHeader
- (IMFlexChainSectionEditModel *(^)(void))deleteHeader;
/// 删除SectionFooter
- (IMFlexChainSectionEditModel *(^)(void))deleteFooter;

/// 删除指定tag的cell
- (IMFlexChainSectionEditModel *(^)(NSInteger tag))deleteCellByTag;
/// 批量删除指定tag的cell（所有该tag的cell）
- (IMFlexChainSectionEditModel *(^)(NSInteger tag))deleteAllCellsByTag;

#pragma mark 刷新
/// 更新视图和cell高度
- (IMFlexChainSectionEditModel *(^)(void))update;
/// 更新cell高度
- (IMFlexChainSectionEditModel *(^)(void))updateCells;

/// 更新SectionHeader高度
- (IMFlexChainSectionEditModel *(^)(void))updateHeader;
/// 更新SectionFooter高度
- (IMFlexChainSectionEditModel *(^)(void))updateFooter;

/// 更新指定tag的cell高度
- (IMFlexChainSectionEditModel *(^)(NSInteger tag))updateCellByTag;
/// 批量更新指定tag的cell高度（所有该tag的cell）
- (IMFlexChainSectionEditModel *(^)(NSInteger tag))updateAllCellsByTag;

@end
