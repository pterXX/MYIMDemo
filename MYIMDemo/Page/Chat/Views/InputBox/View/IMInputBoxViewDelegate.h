
//
//  IMInputBoxViewDelegate.h
//  KXiniuCloud
//
//  Created by eims on 2018/4/27.
//  Copyright © 2018年 EIMS. All rights reserved.
//

#ifndef IMInputBoxViewDelegate_h
#define IMInputBoxViewDelegate_h



@class IMEmojiModel;
@class IMEmojiGroup;
@class IMInputBoxView;
@class IMInputBoxEmojiView;
@class IMInputBoxEmojiMenuView;
@class IMInputBoxEmojiItemView;


@protocol IMInputBoxViewDelegate <NSObject>

@optional
#pragma mark - 表情页面（IMInputBoxEmojiView）代理

/**
 点击选择表情
 
 @param emojiView 表情所在页面
 @param emojiDic 表情数据
 @param emojiType 表情类型
 */
- (void)emojiView:(IMInputBoxEmojiView *)emojiView
   didSelectEmoji:(IMEmojiModel *)emojiDic
        emojiType:(IMEmojiType)emojiType;


/**
 删除光标前面的表情
 */
- (void)emojiViewDeleteEmoji;

/**
 点击发送按钮，发送表情
 
 @param emojiView 表情菜单
 @param emojiStr 发送按钮
 */
- (void)emojiView:(IMInputBoxEmojiView *)emojiView
        sendEmoji:(NSString *)emojiStr;

#pragma mark - 表情菜单代理部分

/**
 点击添加表情按钮
 
 @param menuView 表情菜单
 @param addBut 点击按钮
 */
- (void)emojiMenuView:(IMInputBoxEmojiMenuView *)menuView
      clickAddAction:(UIButton *)addBut;

/**
 选择表情组
 
 @param menuView 表情菜单页面
 @param emojiGroup 表情组
 */
- (void)emojiMenuView:(IMInputBoxEmojiMenuView *)menuView
  didSelectEmojiGroup:(IMEmojiGroup *)emojiGroup;

/**
 点击发送按钮，发送表情
 
 @param menuView 表情菜单
 @param sendBut 发送按钮
 */
- (void)emojiMenuView:(IMInputBoxEmojiMenuView *)menuView
            sendEmoji:(UIButton *)sendBut;

#pragma mark - 输入框代理部分

/**
 通过输入的文字的变化，改变输入框的高度
 
 @param inputBox 输入框
 @param height 改变的高度
 */
- (void)inputBox:(IMInputBoxView *)inputBox changeInputBoxHeight:(CGFloat)height;

/**
 发送消息
 
 @param inputBox 输入框
 @param textMessage 输入的文字内容
 */
- (void)inputBox:(IMInputBoxView *)inputBox
 sendTextMessage:(NSString *)textMessage;

/**
 状态改变
 
 @param inputBox 输入框
 @param fromStatus 上一个状态
 @param toStatus 当前状态
 */
- (void)inputBox:(IMInputBoxView *)inputBox
changeStatusForm:(IMInputBoxStatus)fromStatus
              to:(IMInputBoxStatus)toStatus;

/**
 点击输入框更多按钮事件
 
 @param inputBox 输入框
 @param inputStatus 当前状态
 */
- (void)inputBox:(IMInputBoxView *)inputBox
  clickMoreInput:(IMInputBoxStatus)inputStatus;

@end

#endif /* IMInputBoxViewDelegate_h */
