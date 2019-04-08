//
//  IMFLEXChainViewBatchModel.h
//  zhuanzhuan
//
//  Created by 李伯坤 on 2017/8/15.
//  Copyright © 2017年 转转. All rights reserved.
//

/**
 *  向section中批量添加cells
 */

#import <Foundation/Foundation.h>

#pragma mark - ## IMFLEXChainViewBatchBaseModel (批量，基类)
@interface IMFLEXChainViewBatchBaseModel<IMFLEXReturnType> : NSObject

/// 将cells添加到某个section
- (IMFLEXReturnType (^)(NSInteger section))toSection;

/// cells的数据源
- (IMFLEXReturnType (^)(NSArray *dataModelArray))withDataModelArray;

/// cells内部事件deledate，与blcok二选一即可
- (IMFLEXReturnType (^)(id delegate))delegate;
/// cells内部事件block，与deledate二选一即可
- (IMFLEXReturnType (^)(id ((^)(NSInteger actionType, id data))))eventAction;

/// cells selected事件
- (IMFLEXReturnType (^)(void ((^)(id data))))selectedAction;

/// cells tag
- (IMFLEXReturnType (^)(NSInteger viewTag))viewTag;

/// 框架内部使用
- (id)initWithClassName:(NSString *)className listData:(NSMutableArray *)listData;

@end

#pragma mark - ## IMFLEXChainViewBatchModel (批量，添加)
@class IMFLEXChainViewBatchModel;
@interface IMFLEXChainViewBatchModel : IMFLEXChainViewBatchBaseModel<IMFLEXChainViewBatchModel *>

@end

#pragma mark - ## IMFLEXChainViewBatchInsertModel (批量，插入)
@class IMFLEXChainViewBatchInsertModel;
@interface IMFLEXChainViewBatchInsertModel : IMFLEXChainViewBatchBaseModel<IMFLEXChainViewBatchInsertModel *>

/// 插入到指定Index
- (IMFLEXChainViewBatchInsertModel *(^)(NSInteger index))toIndex;

/// 插入到某个cell前
- (IMFLEXChainViewBatchInsertModel *(^)(NSInteger sectionTag))beforeCell;

/// 插入到某个cell后
- (IMFLEXChainViewBatchInsertModel *(^)(NSInteger sectionTag))afterCell;

@end
