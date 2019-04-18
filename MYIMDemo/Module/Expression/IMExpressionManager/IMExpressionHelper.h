//
//  IMExpressionHelper.h
//  IMChat
//
//  Created by 徐世杰 on 16/3/11.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMExpressionGroupModel.h"

@interface IMExpressionHelper : NSObject

/// 默认表情（Face）
@property (nonatomic, strong, readonly) IMExpressionGroupModel *defaultFaceGroup;

/// 默认系统Emoji
@property (nonatomic, strong, readonly) IMExpressionGroupModel *defaultSystemEmojiGroup;

/// 用户表情组
@property (nonatomic, strong, readonly) NSArray *userEmojiGroups;

/// 用户收藏的表情
@property (nonatomic, strong, readonly) IMExpressionGroupModel *userPreferEmojiGroup;


+ (IMExpressionHelper *)sharedHelper;

/**
 *  根据groupID获取表情包
 */
- (IMExpressionGroupModel *)emojiGroupByID:(NSString *)groupID;

/**
 *  添加表情包
 */
- (BOOL)addExpressionGroup:(IMExpressionGroupModel *)emojiGroup;

/**
 *  删除表情包
 */
- (BOOL)deleteExpressionGroupByID:(NSString *)groupID;

- (void)updateExpressionGroupModelsStatus:(NSArray *)groupModelArray;


#pragma mark - 下载表情包
- (void)downloadExpressionsWithGroupInfo:(IMExpressionGroupModel *)group
                                progress:(void (^)(CGFloat progress))progress
                                 success:(void (^)(IMExpressionGroupModel *group))success
                                 failure:(void (^)(IMExpressionGroupModel *group, NSString *error))failure;


@end
