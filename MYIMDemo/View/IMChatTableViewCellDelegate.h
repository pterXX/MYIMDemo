//
//  IMChatTableViewCellDelegate.h
//  KXiniuCloud
//
//  Created by eims on 2018/4/25.
//  Copyright © 2018年 EIMS. All rights reserved.
//

#ifndef IMChatTableViewCellDelegate_h
#define IMChatTableViewCellDelegate_h

@class IMMessageModel;
@class IMChatTableViewCell;
@class KConversationModel;
@class IMChatMailTableViewCell;
@class IMChatVoiceTableViewCell;

@protocol IMChatTableViewCellDelegate <NSObject>

/**
 点击cell中的头像

 @param tableViewCell 当前cell
 @param messageModel 当前cell的数据
 */
- (void)chatTableViewCell:(IMChatTableViewCell *)tableViewCell clickAvatarImageViewMessageModel:(IMMessageModel *)messageModel;

/**
 点击消息背景

 @param tableViewCell 当前cell
 @param messageModel 当前cell的数据
 */
- (void)chatTableViewCell:(IMChatTableViewCell *)tableViewCell clickBackgroudImageViewMessageModel:(IMMessageModel *)messageModel;

/**
 当发送失败时点击，发送状态展示视图

 @param tableViewCell 当前cell
 @param conversationModel 会话信息
 @param messageModel 消息
 */
- (void)chatTableViewCell:(IMChatTableViewCell *)tableViewCell clickResendMessageWithConversationModel:(KConversationModel *)conversationModel messageModel:(IMMessageModel *)messageModel;

/**
 点击回复邮件

 @param tableViewCell 当前cell
 @param messageModel 当前cell的数据
 */
- (void)chatTableViewCell:(IMChatMailTableViewCell *)tableViewCell replyMailMessageModel:(IMMessageModel *)messageModel;

/**
 点击回复全部

 @param tableViewCell 当前cell
 @param messageModel 当前cell的数据
 */
- (void)chatTableViewCell:(IMChatMailTableViewCell *)tableViewCell
replyAllMaillMessageModel:(IMMessageModel *)messageModel;

/**
 点击转发邮件

 @param tableViewCell 当前cell
 @param messageModel 当前cell的数据
 */
- (void)chatTableViewCell:(IMChatMailTableViewCell *)tableViewCell
 transmitMailMessageModel:(IMMessageModel *)messageModel;

/**
 点击语音消息

 @param tableViewCell 当前cell
 @param messageModel 当前数据
 */
- (void)chatTableViewCell:(IMChatVoiceTableViewCell *)tableViewCell clickVoiceMessageMessageModel:(IMMessageModel *)messageModel;

@end

#endif /* IMChatTableViewCellDelegate_h */
