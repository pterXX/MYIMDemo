//
//  IMFlexChainViewBatchModel.h
//  zhuanzhuan
//
//  Created by 徐世杰 on 2017/8/15.
//  Copyright © 2017年 转转. All rights reserved.
//

/**
 *  向section中批量添加cells
 */

#import <Foundation/Foundation.h>
#import "IMFlexMacros.h"
#pragma mark - ## IMFlexChainViewBatchBaseModel (批量，基类)
@interface IMFlexChainViewBatchBaseModel<IMFlexReturnType> : NSObject

/// 将cells添加到某个section
- (IMFlexReturnType (^)(NSInteger section))toSection;

/// cells的数据源
- (IMFlexReturnType (^)(NSArray *dataModelArray))withDataModelArray;

/// cells内部事件deledate，与blcok二选一即可
- (IMFlexReturnType (^)(id delegate))delegate;
/// cells内部事件block，与deledate二选一即可
- (IMFlexReturnType (^)(id ((^)(NSInteger actionType, id data))))eventAction;

/// cells selected事件
- (IMFlexReturnType (^)(void ((^)(id data))))selectedAction;

/// cells tag
- (IMFlexReturnType (^)(NSInteger viewTag))viewTag;

/// 框架内部使用
- (id)initWithClassName:(NSString *)className listData:(NSMutableArray *)listData;

@end

#pragma mark - ## IMFlexChainViewBatchModel (批量，添加)
@class IMFlexChainViewBatchModel;
@interface IMFlexChainViewBatchModel : IMFlexChainViewBatchBaseModel<IMFlexChainViewBatchModel *>

@end

#pragma mark - ## IMFlexChainViewBatchInsertModel (批量，插入)
@class IMFlexChainViewBatchInsertModel;
@interface IMFlexChainViewBatchInsertModel : IMFlexChainViewBatchBaseModel<IMFlexChainViewBatchInsertModel *>

/// 插入到指定Index
- (IMFlexChainViewBatchInsertModel *(^)(NSInteger index))toIndex;

/// 插入到某个cell前
- (IMFlexChainViewBatchInsertModel *(^)(NSInteger sectionTag))beforeCell;

/// 插入到某个cell后
- (IMFlexChainViewBatchInsertModel *(^)(NSInteger sectionTag))afterCell;

@end
