//
//  IMDBConversationStore.h
//  IMChat
//
//  Created by 徐世杰 on 16/3/20.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "IMDBBaseStore.h"

@interface IMDBConversationStore : IMDBBaseStore

/**
 *  新的会话（未读）
 */
- (BOOL)addConversationByUid:(NSString *)uid fid:(NSString *)fid type:(NSInteger)type date:(NSDate *)date;

/**
 *  更新会话状态（已读）
 */
- (void)updateConversationByUid:(NSString *)uid fid:(NSString *)fid;

/**
 *  查询所有会话
 */
- (NSArray *)conversationsByUid:(NSString *)uid;

/**
 *  未读消息数
 */
- (NSInteger)unreadMessageByUid:(NSString *)uid fid:(NSString *)fid;

/**
 *  删除单条会话
 */
- (BOOL)deleteConversationByUid:(NSString *)uid fid:(NSString *)fid;

/**
 *  删除用户的所有会话
 */
- (BOOL)deleteConversationsByUid:(NSString *)uid;


@end
