//
//  IMStyleHeader.h
//  MYIMDemo
//
//  Created by admin on 2019/3/25.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#ifndef IMStyleHeader_h
#define IMStyleHeader_h

#pragma mark - 消息输入框
// 输入框字体颜色
#define INPUT_BOX_TEXTCOLOR [UIColor darkGrayColor]
// 输入字体大小
#define INPUT_BOX_TEXT_FONT 15
// 输入框最大高度
#define INPUT_BOX_TEXT_MAX_HEIGHT 104
// 输入文本框的默认高度
#define INPUT_BOX_TEXT_MIN_HEIGHT 34
// 输入框高度
#define INPUT_BOX_HEIGHT 49
// 输入框与父视图的间隔
#define INPUT_BOX_BACKGROUND_SPACE 8
// 输入框-键盘按钮图片
#define INPUT_BOX_KEYBOARD_IMAGE [UIImage imageNamed:@"icon_message_keyboard"]
// 输入框-语音按钮图片
#define INPUT_BOX_VOICE_IMAGE [UIImage imageNamed:@"icon_message_voiceBtn"]
// 输入框-表情按钮图片
#define INPUT_BOX_FACE_IMAGE [UIImage imageNamed:@"icon_message_expression"]
// 输入框-更多按钮图片
#define INPUT_BOX_MORE_IMAGE [UIImage imageNamed:@"icon_message_more"]
// 表情框高度
#define INPUT_BOX_EMOJI_VIEW_HEIGHT 215
// 表情页高度 (INPUT_BOX_EMOJI_VIEW_HEIGHT - EMOJI_ITEM_HEIGHT(表情菜单高度) - 15(pageCtrl高度))
#define INPUT_BOX_EMOJI_HEIGHT 141
// item宽度
static const CGFloat ITEM_WIDTH = 40;
// item高度
static const CGFloat ITEM_HEIGHT = 40;
// 常规表情一行能显示的个数
#define NORMARL_EMOJI_ROW_COUNT IMSCREEN_WIDTH >= 375 ? 8 : 7

static const CGFloat krowSpacing = 5;

#define kcolumnSpacing ((IMSCREEN_WIDTH - (NORMARL_EMOJI_ROW_COUNT * ITEM_WIDTH))/(NORMARL_EMOJI_ROW_COUNT + 1))
// 菜单表情高度
static const CGFloat  MENU_EMOJI_ITEM_HEIGHT = 44;

// 动画表情一行能显示的个数
static const CGFloat GIF_EMOJI_ROW_COUNT = 4;
// 底部间隔
#define BOTTOM_SPACE IMTABBAR_HEIGHT - 49
// 表情间的间隔
static const CGFloat EMOJI_SPACE = 2;

#pragma mark - 输入框更多页面
// 输入框更多视图高度
#define INPUT_BOX_MORE_VIEW_HEIGHT 215
// item之间的横线间隔
#define INPUT_BOX_MORE_ITEM_H_INTERVAL 15
// item的宽度
#define INPUT_BOX_MORE_ITEM_WIDTH 60

// item之间的纵向间隔
#define INPUT_BOX_MORE_ITEM_V_INTERVAL (IMSCREEN_WIDTH - 4 * INPUT_BOX_MORE_ITEM_WIDTH)/5.f

#define INPUT_BOX_MORE_ITEM_HEIGHT (INPUT_BOX_MORE_VIEW_HEIGHT - 10 - 2 * INPUT_BOX_MORE_ITEM_H_INTERVAL) / 2.f


#pragma mark - 聊天页面
// 行间距
#define LINESPACE 1.225
// 头像宽度
#define AVATAR_WIDTH 40
// 头像与屏幕之间的间隔
#define AVATAR_SCREEN_SPACE 10
// 头像与用户名之间的间隔
#define AVATAR_USERNAME_SPACE 10
// 消息与背景框的间距（左右）
#define MESSAGE_BACKGROUND_SPACE 10
// 最大空余间隔
#define MESSAGE_MAX_FREE_SPACE 70
// 用户名高度（18）+ 间隔（2）
#define USERNAME_HEIGHT 18
// 用户名字体大小
#define USERNAME_FONT 15
// 聊天文本字体大小
#define CHAT_MESSAGE_FONT 16
// 邮件中详情字体大小
#define MAIL_DETAIL_FONT 14
// 邮件中邮件标题能出现的最大高度
#define MAIL_TITLE_MAX_HEIGHT 160
// 邮件消息最大行高 = 10 + 10 + 最顶部的16 + 4 + mailTitle高度（最大高度165） + 4 + mailDetail高度（最小高度20） + 5 + 附件高度(32) + 5 +底部高度（40） + 10 + 10
// 收到邮件是的最大高度
// 修改此高度可以到达修改默认邮件详情的效果
#define RECEIVE_MAIL_MAX_ROW_HEIGHT 324
// 由于自己发的邮件没有“回复”、“回复全部”和“转发”
#define SENDER_MAIL_MAX_ROW_HEIGHT 291
// 邮件附件高度
#define MAIL_ATTACHMENT_HEIGHT 25
// 自己发的邮件是否显示“回复”、“回复全部”和“转发”  默认不显示
#define SELF_SENDER_MAIL_SHOW_REPLY NO
// 消息页面昵称字体大小
#define MESSAGE_NICKNAME_FONT 14
// 显示消息时间时的新增高度
#define SHOW_MESSAGE_TIME_HEIGHT 30

// 用户名字体颜色
#define USERNAME_TEXTCOLOR           [UIColor darkGrayColor]
// 聊天文本字体颜色
#define CHAT_MESSAGE_TEXTCOLOR       [UIColor darkGrayColor]
// 邮件标题颜色
#define MAIL_TITLE_TEXTCOLOR         [IMColorTools colorWithHexString:@"0x444444"]
// 邮件详情颜色
#define MAIL_DETAIL_TEXTCOLOR        [UIColor lightGrayColor]
// 自己发送的详情颜色
#define MAIL_DETAIL_TEXTCOLOR_SENDER [IMColorTools colorWithHexString:@"0x666666"]

// 消息框最大宽度
#define MESSAGE_MAX_WIDTH            (IMSCREEN_WIDTH - (AVATAR_SCREEN_SPACE + AVATAR_WIDTH + AVATAR_USERNAME_SPACE) - MESSAGE_MAX_FREE_SPACE)
// 图片最大高度
#define IMAGE_MAX_HEIGHT             (IMSCREEN_HEIGHT - IMSTATUSBAR_NAVBAR_HEIGHT - IMTABBAR_HEIGHT - 100)
// 最大的语音长度
#define MAX_VOICE_LENGTH             60 * 1000.f

#endif /* IMStyleHeader_h */
