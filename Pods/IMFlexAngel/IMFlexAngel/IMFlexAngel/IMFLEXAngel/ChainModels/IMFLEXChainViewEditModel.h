//
//  IMFLEXChainViewEditModel.h
//  IMFLEXDemo
//
//  Created by 李伯坤 on 2017/12/11.
//  Copyright © 2017年 李伯坤. All rights reserved.
//

/**
 *  cell删除，仅删除满足条件的第一个
 */

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, IMFLEXChainViewEditType) {
    IMFLEXChainViewEditTypeDelete,
    IMFLEXChainViewEditTypeUpdate,
    IMFLEXChainViewEditTypeDataModel,
    IMFLEXChainViewEditTypeHas,
};

#pragma mark - ## IMFLEXChainViewEditModel (单个)
@interface IMFLEXChainViewEditModel : NSObject

/// 根据cellTag
- (id (^)(NSInteger viewTag))byViewTag;

/// 根据数据源
- (id (^)(id dataModel))byDataModel;

/// 根据类名
- (id (^)(NSString *className))byViewClassName;

/// 根据indexPath
- (id (^)(NSIndexPath *indexPath))atIndexPath;

/// 框架内部使用
- (instancetype)initWithType:(IMFLEXChainViewEditType)type andListData:(NSArray *)listData;

@end

#pragma mark - ## IMFLEXChainViewBatchEditModel (批量)
@interface IMFLEXChainViewBatchEditModel : NSObject

/// 所有
- (NSArray *(^)(void))all;

/// 根据cellTag
- (NSArray *(^)(NSInteger viewTag))byViewTag;

/// 根据数据源
- (NSArray *(^)(id dataModel))byDataModel;

/// 根据类名
- (NSArray *(^)(NSString *className))byViewClassName;

/// 框架内部使用
- (instancetype)initWithType:(IMFLEXChainViewEditType)type andListData:(NSArray *)listData;

@end
