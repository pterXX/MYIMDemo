//
//  IMDBExpressionStore.h
//  IMChat
//
//  Created by 徐世杰 on 16/4/9.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "IMDBBaseStore.h"
#import "IMExpressionGroupModel.h"

@interface IMDBExpressionStore : IMDBBaseStore

/**
 *  添加表情包
 */
- (BOOL)addExpressionGroup:(IMExpressionGroupModel *)group forUid:(NSString *)uid;

/**
 *  查询所有表情包
 */
- (NSArray *)expressionGroupsByUid:(NSString *)uid;

/**
 *  删除表情包
 */
- (BOOL)deleteExpressionGroupByID:(NSString *)gid forUid:(NSString *)uid;

/**
 *  拥有某表情包的用户数
 */
- (NSInteger)countOfUserWhoHasExpressionGroup:(NSString *)gid;


@end
