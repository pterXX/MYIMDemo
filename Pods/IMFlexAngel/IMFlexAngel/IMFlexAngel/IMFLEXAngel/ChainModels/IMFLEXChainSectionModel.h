//
//  IMFLEXChainSectionModel.h
//  zhuanzhuan
//
//  Created by 李伯坤 on 2017/8/15.
//  Copyright © 2017年 转转. All rights reserved.
//

/**
 *  向列表中添加Section
 */

#import <UIKit/UIKit.h>

@class IMFlexibleLayoutSectionModel;

#pragma mark - ## IMFLEXChainSectionBaseModel (基类)
@interface IMFLEXChainSectionBaseModel<IMFLEXReturnType> : NSObject

/// 最小行间距
- (IMFLEXReturnType (^)(CGFloat minimumLineSpacing))minimumLineSpacing;
/// 最小元素间距
- (IMFLEXReturnType (^)(CGFloat minimumInteritemSpacing))minimumInteritemSpacing;
/// sectionInsets
- (IMFLEXReturnType (^)(UIEdgeInsets sectionInsets))sectionInsets;
/// backgrounColor
- (IMFLEXReturnType (^)(UIColor *backgrounColor))backgrounColor;

/// 初始化，框架内部使用
- (instancetype)initWithSectionModel:(IMFlexibleLayoutSectionModel *)sectionModel;

@end

#pragma mark - ## IMFLEXChainSectionModel （添加）
@class IMFLEXChainSectionModel;
@interface IMFLEXChainSectionModel : IMFLEXChainSectionBaseModel <IMFLEXChainSectionModel *>

@end

#pragma mark - ## IMFLEXChainSectionInsertModel （插入）
@class IMFLEXChainSectionInsertModel;
@interface IMFLEXChainSectionInsertModel : IMFLEXChainSectionBaseModel <IMFLEXChainSectionInsertModel *>

/// 插入到指定Index
- (IMFLEXChainSectionInsertModel *(^)(NSInteger index))toIndex;

/// 插入到某个section前
- (IMFLEXChainSectionInsertModel *(^)(NSInteger sectionTag))beforeSection;

/// 插入到某个section后
- (IMFLEXChainSectionInsertModel *(^)(NSInteger sectionTag))afterSection;

/// 框架内部使用
- (instancetype)initWithSectionModel:(IMFlexibleLayoutSectionModel *)sectionModel listData:(NSMutableArray *)listData;

@end

#pragma mark - ## IMFLEXChainSectionEditModel （编辑）
@class IMFLEXChainSectionEditModel;
@interface IMFLEXChainSectionEditModel : IMFLEXChainSectionBaseModel <IMFLEXChainSectionEditModel *>

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
- (IMFLEXChainSectionEditModel *(^)(void))clear;
/// 清空所有cell
- (IMFLEXChainSectionEditModel *(^)(void))clearCells;

/// 删除SectionHeader
- (IMFLEXChainSectionEditModel *(^)(void))deleteHeader;
/// 删除SectionFooter
- (IMFLEXChainSectionEditModel *(^)(void))deleteFooter;

/// 删除指定tag的cell
- (IMFLEXChainSectionEditModel *(^)(NSInteger tag))deleteCellByTag;
/// 批量删除指定tag的cell（所有该tag的cell）
- (IMFLEXChainSectionEditModel *(^)(NSInteger tag))deleteAllCellsByTag;

#pragma mark 刷新
/// 更新视图和cell高度
- (IMFLEXChainSectionEditModel *(^)(void))update;
/// 更新cell高度
- (IMFLEXChainSectionEditModel *(^)(void))updateCells;

/// 更新SectionHeader高度
- (IMFLEXChainSectionEditModel *(^)(void))updateHeader;
/// 更新SectionFooter高度
- (IMFLEXChainSectionEditModel *(^)(void))updateFooter;

/// 更新指定tag的cell高度
- (IMFLEXChainSectionEditModel *(^)(NSInteger tag))updateCellByTag;
/// 批量更新指定tag的cell高度（所有该tag的cell）
- (IMFLEXChainSectionEditModel *(^)(NSInteger tag))updateAllCellsByTag;

@end
