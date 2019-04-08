//
//  IMFLEXEditModel.h
//  zhuanzhuan
//
//  Created by 李伯坤 on 2017/8/15.
//  Copyright © 2017年 转转. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMFLEXEditModelProtocol.h"

extern NSString *const IMFLEXEditErrorDomain;

/// 创建EditModel
@class IMFLEXEditModel;
IMFLEXEditModel *createFLEXEditModel(NSInteger tag,
                                     id titleModel,
                                     id placeholderModel,
                                     id value,
                                     id sourceModel,
                                     NSError* (^inputlegitimacyCheckAction)(IMFLEXEditModel *model),
                                     void (^completetAction)(IMFLEXEditModel *model));

@interface IMFLEXEditModel : NSObject <IMFLEXEditModelProtocol>

@property (nonatomic, assign) NSInteger tag;

/// 源Model
@property (nonatomic, strong) id sourceModel;

#pragma mark - # 通用参数
/// 标题模型
@property (nonatomic, strong) id titleModel;
@property (nonatomic, strong) id titleModel1;
@property (nonatomic, strong) id titleModel2;
@property (nonatomic, strong) id titleModel3;

/// 占位符模型
@property (nonatomic, strong) id placeholderModel;
@property (nonatomic, strong) id placeholderModel1;
@property (nonatomic, strong) id placeholderModel2;
@property (nonatomic, strong) id placeholderModel3;

/// 自定义信息模型
@property (nonatomic, strong) id userInfo;

/// 用户输入值
@property (nonatomic, strong) id value;
@property (nonatomic, strong) id value1;
@property (nonatomic, strong) id value2;
@property (nonatomic, strong) id value3;

@end
