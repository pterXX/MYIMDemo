//
//  IMFLEXEditModel.m
//  zhuanzhuan
//
//  Created by 李伯坤 on 2017/8/15.
//  Copyright © 2017年 转转. All rights reserved.
//

#import "IMFLEXEditModel.h"

NSString *const IMFLEXEditErrorDomain = @"IMFLEXEditErrorDomain";

@interface IMFLEXEditModel ()

/// 输入合法性检查，IMFLEXEditModelProtocol中checkInputlegitimacy方法，默认执行此block
@property (nonatomic, copy) NSError* (^inputlegitimacyCheckAction)(IMFLEXEditModel *model);

/// 输入完成执行此block，给sourceModel赋值
@property (nonatomic, copy) void (^completetAction)(IMFLEXEditModel *model);

@property (nonatomic, strong) NSDictionary *cache;

@end

@implementation IMFLEXEditModel

- (NSError *)checkInputlegitimacy
{
    if (self.inputlegitimacyCheckAction) {
        return self.inputlegitimacyCheckAction(self);
    }
    return nil;
}

- (void)excuteCompleteAction
{
    if (self.completetAction) {
        self.completetAction(self);
    }
}

@end

IMFLEXEditModel *createFLEXEditModel(NSInteger tag, id titleModel, id placeholderModel, id value, id sourceModel, NSError* (^inputlegitimacyCheckAction)(IMFLEXEditModel *model), void (^completetAction)(IMFLEXEditModel *model))
{
    IMFLEXEditModel *model = [[IMFLEXEditModel alloc] init];
    model.tag = tag;
    model.titleModel = titleModel;
    model.placeholderModel = placeholderModel;
    model.value = value;
    model.sourceModel = sourceModel;
    model.inputlegitimacyCheckAction = inputlegitimacyCheckAction;
    model.completetAction = completetAction;
    return model;
}

