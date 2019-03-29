//
//  IMChatMessageDisplayViewDelegate.h
//  IMChat
//
//  Created by 徐世杰 on 16/3/23.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IMUser;
@class IMMessage;
@class IMChatMessageDisplayView;
@protocol IMChatMessageDisplayViewDelegate <NSObject>

/**
 *  聊天界面点击事件，用于收键盘
 */
- (void)chatMessageDisplayViewDidTouched:(IMChatMessageDisplayView *)chatTVC;

/**
 *  下拉刷新，获取某个时间段的聊天记录（异步）
 *
 *  @param chatTVC   chatTVC
 *  @param date      开始时间
 *  @param count     条数
 *  @param completed 结果Blcok
 */
- (void)chatMessageDisplayView:(IMChatMessageDisplayView *)chatTVC
            getRecordsFromDate:(NSDate *)date
                         count:(NSUInteger)count
                     completed:(void (^)(NSDate *, NSArray *, BOOL))completed;

@optional
/**
 *  消息长按删除
 *
 *  @return 删除是否成功
 */
- (BOOL)chatMessageDisplayView:(IMChatMessageDisplayView *)chatTVC
                 deleteMessage:(IMMessage *)message;

/**
 *  用户头像点击事件
 */
- (void)chatMessageDisplayView:(IMChatMessageDisplayView *)chatTVC
            didClickUserAvatar:(IMUser *)user;

/**
 *  Message点击事件
 */
- (void)chatMessageDisplayView:(IMChatMessageDisplayView *)chatTVC
               didClickMessage:(IMMessage *)message;

/**
 *  Message双击事件
 */
- (void)chatMessageDisplayView:(IMChatMessageDisplayView *)chatTVC
         didDoubleClickMessage:(IMMessage *)message;

@end
