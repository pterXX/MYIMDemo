//
//  IMChatMessageHelper.h
//  MYIMDemo
//
//  Created by 徐世杰 on 2019/3/1.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import <Foundation/Foundation.h>



NS_ASSUME_NONNULL_BEGIN

@interface IMChatMessageHelper : NSObject

/**
 输入框显示是不是表情，而是表情字符串
 
 @param text 字符串
 @return 富文本
 */
+ (NSAttributedString *)formatMessageString:(NSString *)text;

/**
 在消息页面显示的富文本
 
 @param att 输入框得到的富文本
 @return 处理好的可以显示在页面上的富文本
 */
+ (NSAttributedString *)formatMessageAtt:(NSAttributedString *)att;
@end

NS_ASSUME_NONNULL_END
