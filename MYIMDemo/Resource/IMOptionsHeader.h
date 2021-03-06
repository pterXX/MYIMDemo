//
//  IMOptionsHeader.h
//  MYIMDemo
//
//  Created by admin on 2019/3/25.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#ifndef IMOptionsHeader_h
#define IMOptionsHeader_h


#pragma mark - 输入框枚举
typedef NS_OPTIONS(NSUInteger, IMInputStatus) {
    IMInputStatusNone = 0,          // 无状态
    IMInputStatusEmoji,             // 表情
    IMInputStatusText,              // 文字
};

typedef NS_OPTIONS(NSUInteger, IMInputBoxStatus) {
    IMInputBoxStatusNone = 0,        // 无状态
    IMInputBoxStatusShowVoice,       // 语音
    IMInputBoxStatusShowEmoji,       // 表情
    IMInputBoxStatusShowMore,        // 更多
    IMInputBoxStatusShowKeyboard,    // 键盘
};

//typedef NS_OPTIONS(NSUInteger, IMEmojiType) {
//    IMEmojiTypeNomarl = 0,   // 正常表情
//    IMEmojiTypeGIF           // 动画
//};

typedef NS_OPTIONS(NSUInteger, IMGlideDirectionTpye) {
    // 没有滑动，用于第一次显示表情组
    IMGlideDirectionTpyeNone = 0,
    // 从左往右滑，目的页面是左页
    IMGlideDirectionTpyeLeft,
    // 从右往左滑，目的页面是右页
    IMGlideDirectionTpyeRight
};

typedef NS_OPTIONS(NSUInteger, IMInputBoxRecordStatus) {
    IMInputBoxRecordStatusNone = 0,           // 初始状态
    IMInputBoxRecordStatusRecording,          // 正在录音
    IMInputBoxRecordStatusMoveOutside,        // 移出
    IMInputBoxRecordStatusMoveInside,         // 移进
    IMInputBoxRecordStatusCancel,             // 上滑取消录音
    IMInputBoxRecordStatusEnd,                // 录音结束
    IMInputBoxRecordStatusTooShort            // 录音太短
};

#pragma mark - 消息枚举
typedef NS_OPTIONS(NSInteger, IMConversationCommonNotification) {
    IMConversationCommonNotificationMail,              // 接收到邮件
    IMConversationCommonNotificationUpdateBedgeNumber, // 更新选中行的未读消息数
    IMConversationCommonNotificationReceiveMessage,    // 收到消息
    IMConversationCommonNotificationNetworkConnectionStatus, // 网络连接状态
    IMConversationCommonNotificationNetworkStatus,     // 网络状态
    IMConversationCommonNotificationEnterForeground    // 从后台进入前台
};

///*
// 消息类型
// */
//typedef NS_OPTIONS(NSInteger, IMMessageType) {
//    IMMessageTypeNone = -1,   // 头部 其他
//    IMMessageTypeText = 0,    // 文字消息  包含表情
//    IMMessageTypeVoice,       // 语音消息
//    IMMessageTypeImage,       // 图片消息
//    IMMessageTypeMail,        // 邮件消息
//    IMMessageTypeVideo,       // 视频消息
//    IMMessageTypeFile,        // 文件消息
//    IMMessageTypeLocation,    // 位置消息
//    IMMessageTypeCard         // 名片消息
//};

/*
 消息发送方
 */
typedef NS_OPTIONS(NSUInteger, IMMessageSenderType) {
    IMMessageSenderTypeSender = 0,    // 发送方
    IMMessageSenderTypeReceiver       // 接收方
};

/*
 消息发送状态
 */
typedef NS_OPTIONS(NSUInteger, IMMessageSendStatus) {
    IMMessageSendStatusSendSuccess = 0,        // 发送成功
    IMMessageSendStatusSendFailure,            // 发送失败
    IMMessageSendStatusSending                 // 正在发送
};

/*
 消息接收状态
 */
typedef NS_OPTIONS(NSUInteger, IMMessageReadStatus) {
    IMMessageReadStatusRead = 0,  // 消息已读
    IMMessageReadStatusUnRead     // 消息未读
};

/**
 聊天室
 */
typedef NS_OPTIONS(NSInteger, IMMessageChatType) {
    IMMessageChatTypeSingle = 0,  // 单聊
    IMMessageChatTypeGroup,       // 群聊
    IMMessageChatTypeFTP,         // 文件传输
    IMMessageChatTypeVisitor      // 游客
};

typedef NS_OPTIONS(NSUInteger, IMInputBoxMoreStatus) {
    IMInputBoxMoreStatusNone = 0,   // 无
    IMInputBoxMoreStatusPhoto,      // 相册选择照片
    IMInputBoxMoreStatusTakePhoto,  // 拍摄
    IMInputBoxMoreStatusMail,       // 云邮
    IMInputBoxMoreStatusCallPhone,  // 拨打电话
    IMInputBoxMoreStatusVideo,      // 视频通话
    IMInputBoxMoreStatusCard,       // 个人名片
    IMInputBoxMoreStatusLocation,   // 位置
    IMInputBoxMoreStatusFile        // 文件
};






#endif /* IMOptionsHeader_h */
