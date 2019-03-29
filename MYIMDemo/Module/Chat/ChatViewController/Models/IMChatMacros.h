//
//  IMChatMacros.h
//  IMChat
//
//  Created by 徐世杰 on 16/2/19.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#ifndef IMChatMacros_h
#define IMChatMacros_h
#import <UIKit/UIKit.h>

#define     HEIGHT_CHATBAR_TEXTVIEW         36.0f
#define     HEIGHT_MAX_CHATBAR_TEXTVIEW     111.5f
#define     HEIGHT_CHAT_KEYBOARD            215.0f

typedef NS_ENUM(NSInteger, IMEmojiType) {
    IMEmojiTypeEmoji,
    IMEmojiTypeFavorite,
    IMEmojiTypeFace,
    IMEmojiTypeImage,
    IMEmojiTypeImageWithTitle,
    IMEmojiTypeOther,
};

typedef NS_ENUM(NSInteger, IMChatBarStatus) {
    IMChatBarStatusInit,
    IMChatBarStatusVoice,
    IMChatBarStatusEmoji,
    IMChatBarStatusMore,
    IMChatBarStatusKeyboard,
};


#endif /* IMChatMacros_h */
