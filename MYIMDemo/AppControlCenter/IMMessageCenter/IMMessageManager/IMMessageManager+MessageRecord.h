//
//  IMMessageManager+MessageRecord.h
//  IMChat
//
//  Created by 徐世杰 on 16/3/20.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "IMMessageManager.h"

@interface IMMessageManager (MessageRecord)

#pragma mark - 查询
/**
 *  查询聊天记录
 */
- (void)messageRecordForPartner:(NSString *)partnerID
                       fromDate:(NSDate *)date
                          count:(NSUInteger)count
                       complete:(void (^)(NSArray *, BOOL))complete;

/**
 *  查询聊天文件
 */
- (void)chatFilesForPartnerID:(NSString *)partnerID
                    completed:(void (^)(NSArray *))completed;


/**
 *  查询聊天图片
 */
- (void)chatImagesAndVideosForPartnerID:(NSString *)partnerID
                              completed:(void (^)(NSArray *))completed;

#pragma mark - 删除
/**
 *  删除单条聊天记录
 */
- (BOOL)deleteMessageByMsgID:(NSString *)msgID;

/**
 *  删除与某好友的聊天记录
 */
- (BOOL)deleteMessagesByPartnerID:(NSString *)partnerID;

/**
 *  删除所有聊天记录
 */
- (BOOL)deleteAllMessages;

@end
