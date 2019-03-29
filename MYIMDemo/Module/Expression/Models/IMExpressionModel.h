//
//  IMExpressionModel.h
//  IMChat
//
//  Created by 徐世杰 on 16/2/20.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMChatMacros.h"

@interface IMExpressionModel : NSObject

/// 表情类型
@property (nonatomic, assign) IMEmojiType type;

/// 表情包id
@property (nonatomic, strong) NSString *gid;

/// 表情id
@property (nonatomic, strong) NSString *eId;

/// 表情名
@property (nonatomic, strong) NSString *name;

/// 远程url
@property (nonatomic, strong) NSString *url;

/// 本地路径
@property (nonatomic, strong, readonly) NSString *path;

/// 表情大小
@property (nonatomic, assign) CGFloat size;

/**
 *  根据eid获取表情url
 */
+ (NSString *)expressionURLWithEid:(NSString *)eid;

/**
 *  根据eid获取表情下载url
 */
+ (NSString *)expressionDownloadURLWithEid:(NSString *)eid;

@end
