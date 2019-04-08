//
//  IMFLEXChainViewModel.h
//  zhuanzhuan
//
//  Created by 李伯坤 on 2017/8/15.
//  Copyright © 2017年 转转. All rights reserved.
//

/**
 *  向section中添加视图(cell/header/footer)
 */

#import <Foundation/Foundation.h>

#pragma mark - ## IMFLEXChainViewBaseModel (单个，基类)
typedef NS_ENUM(NSInteger, IMFLEXChainViewType) {
    IMFLEXChainViewTypeCell,
    IMFLEXChainViewTypeHeader,
    IMFLEXChainViewTypeFooter,
};

@class IMFlexibleLayoutViewModel;
@interface IMFLEXChainViewBaseModel<IMFLEXReturnType> : NSObject

/// 将cell添加到某个section
- (IMFLEXReturnType (^)(NSInteger section))toSection;

/// cell的数据源
- (IMFLEXReturnType (^)(id dataModel))withDataModel;

/// cell内部事件deledate，与blcok二选一即可
- (IMFLEXReturnType (^)(id delegate))delegate;
/// cell内部事件block，与deledate二选一即可
- (IMFLEXReturnType (^)(id ((^)(NSInteger actionType, id data))))eventAction;

/// cell selected事件
- (IMFLEXReturnType (^)(void ((^)(id data))))selectedAction;

/// cell tag
- (IMFLEXReturnType (^)(NSInteger viewTag))viewTag;

/// 框架内部使用
@property (nonatomic, assign, readonly) IMFLEXChainViewType type;
- (id)initWithListData:(NSMutableArray *)listData viewModel:(IMFlexibleLayoutViewModel *)viewModel andType:(IMFLEXChainViewType)type;

@end

#pragma mark - ## IMFLEXChainViewModel （单个，添加）
@class IMFLEXChainViewModel;
@interface IMFLEXChainViewModel : IMFLEXChainViewBaseModel <IMFLEXChainViewModel *>

@end

#pragma mark - ## IMFLEXChainViewInsertModel （单个，插入）
@class IMFLEXChainViewInsertModel;
@interface IMFLEXChainViewInsertModel : IMFLEXChainViewBaseModel <IMFLEXChainViewInsertModel *>

/// 插入到指定Index
- (IMFLEXChainViewInsertModel *(^)(NSInteger index))toIndex;

/// 插入到某个cell前
- (IMFLEXChainViewInsertModel *(^)(NSInteger sectionTag))beforeCell;

/// 插入到某个cell后
- (IMFLEXChainViewInsertModel *(^)(NSInteger sectionTag))afterCell;

@end
