//
//  IMFlexChainViewModel.h
//  zhuanzhuan
//
//  Created by 徐世杰 on 2017/8/15.
//  Copyright © 2017年 转转. All rights reserved.
//

/**
 *  向section中添加视图(cell/header/footer)
 */

#import <Foundation/Foundation.h>
#import "IMFlexMacros.h"
#pragma mark - ## IMFlexChainViewBaseModel (单个，基类)
typedef NS_ENUM(NSInteger, IMFlexChainViewType) {
    IMFlexChainViewTypeCell,
    IMFlexChainViewTypeHeader,
    IMFlexChainViewTypeFooter,
};

@class IMFlexibleLayoutViewModel;
@interface IMFlexChainViewBaseModel<IMFlexReturnType> : NSObject

/// 将cell添加到某个section
- (IMFlexReturnType (^)(NSInteger section))toSection;

/// cell的数据源
- (IMFlexReturnType (^)(id dataModel))withDataModel;

/// cell内部事件deledate，与blcok二选一即可
- (IMFlexReturnType (^)(id delegate))delegate;
/// cell内部事件block，与deledate二选一即可
- (IMFlexReturnType (^)(id ((^)(NSInteger actionType, id data))))eventAction;

/// cell selected事件
- (IMFlexReturnType (^)(void ((^)(id data))))selectedAction;

/// cell tag
- (IMFlexReturnType (^)(NSInteger viewTag))viewTag;

/// 框架内部使用
@property (nonatomic, assign, readonly) IMFlexChainViewType type;
- (id)initWithListData:(NSMutableArray *)listData viewModel:(IMFlexibleLayoutViewModel *)viewModel andType:(IMFlexChainViewType)type;

@end

#pragma mark - ## IMFlexChainViewModel （单个，添加）
@class IMFlexChainViewModel;
@interface IMFlexChainViewModel : IMFlexChainViewBaseModel <IMFlexChainViewModel *>

@end

#pragma mark - ## IMFlexChainViewInsertModel （单个，插入）
@class IMFlexChainViewInsertModel;
@interface IMFlexChainViewInsertModel : IMFlexChainViewBaseModel <IMFlexChainViewInsertModel *>

/// 插入到指定Index
- (IMFlexChainViewInsertModel *(^)(NSInteger index))toIndex;

/// 插入到某个cell前
- (IMFlexChainViewInsertModel *(^)(NSInteger sectionTag))beforeCell;

/// 插入到某个cell后
- (IMFlexChainViewInsertModel *(^)(NSInteger sectionTag))afterCell;

@end
