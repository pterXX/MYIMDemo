//
//  IMMessageConstants.h
//  IMChat
//
//  Created by 徐世杰 on 2017/9/20.
//  Copyright © 2017年 徐世杰. All rights reserved.
//

#ifndef IMMessageConstants_h
#define IMMessageConstants_h

/**
 *  消息类型
 */
typedef NS_ENUM(NSInteger, IMMessageType) {
    IMMessageTypeUnknown,
    IMMessageTypeText,          // 文字
    IMMessageTypeImage,         // 图片
    IMMessageTypeExpression,    // 表情
    IMMessageTypeVoice,         // 语音
    IMMessageTypeVideo,         // 视频
    IMMessageTypeURL,           // 链接
    IMMessageTypePosition,      // 位置
    IMMessageTypeBusinessCard,  // 名片
    IMMessageTypeSystem,        // 系统
    IMMessageTypeOther,
};


#define     MAX_MESSAGE_WIDTH               SCREEN_WIDTH * 0.58
#define     MAX_MESSAGE_IMAGE_WIDTH         SCREEN_WIDTH * 0.45
#define     MIN_MESSAGE_IMAGE_WIDTH         SCREEN_WIDTH * 0.25
#define     MAX_MESSAGE_EXPRESSION_WIDTH    SCREEN_WIDTH * 0.35
#define     MIN_MESSAGE_EXPRESSION_WIDTH    SCREEN_WIDTH * 0.2

#endif /* IMMessageConstants_h */
