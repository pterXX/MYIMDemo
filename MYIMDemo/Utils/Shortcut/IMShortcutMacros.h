//
//  IMShortcutMacros.h
//  MYIMDemo
//
//  Created by 徐世杰 on 2019/3/1.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#ifndef IMShortcutMacros_h
#define IMShortcutMacros_h

#import "IMShortcutMethod.h"

#pragma mark - # 屏幕尺寸
#define     IMSCREEN_SIZE                 [UIScreen mainScreen].bounds.size
#define     IMSCREEN_WIDTH                IMSCREEN_SIZE.width
#define     IMSCREEN_HEIGHT               IMSCREEN_SIZE.height

#pragma mark - # 常用控件高度
#define     IMSTATUSBAR_HEIGHT            ([[UIApplication sharedApplication] statusBarFrame].size.height)
#define     IMTABBAR_HEIGHT               (isNotchScreen() ? 49.0f + 34.0f : 49.0f)
#define     IMNAVBAR_HEIGHT               44.0f
#define     IMSTATUSBAR_NAVBAR_HEIGHT     (IMSTATUSBAR_HEIGHT + IMNAVBAR_HEIGHT)
#define     IMSEARCHBAR_HEIGHT            (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0") ? 52.0f : 44.0f)
#define     IMBORDER_WIDTH_1PX            ([[UIScreen mainScreen] scale] > 0.0 ? 1.0 / [[UIScreen mainScreen] scale] : 1.0)

#define     IMSAFEAREA_INSETS     \
({   \
UIEdgeInsets edgeInsets = UIEdgeInsetsZero; \
if (@available(iOS 11.0, *)) {      \
edgeInsets = [UIApplication sharedApplication].keyWindow.safeAreaInsets;     \
}   \
edgeInsets;  \
})\

#define     IMSAFEAREA_INSETS_BOTTOM      (IMSAFEAREA_INSETS.bottom)

#pragma mark - # 系统方法简写
/// 广播中心
#define     IMNotificationCenter        [NSNotificationCenter defaultCenter]
/// 用户自定义数据
#define     IMUserDefaults              [NSUserDefaults standardUserDefaults]
/// URL
#define     IMURL(urlString)            [NSURL URLWithString:urlString]
/// 图片
#define     IMImage(imageName)          (imageName ? [UIImage imageNamed:imageName] : nil)
#define     IMPNG(X)                    [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:X ofType:@"png"]]
#define     IMJPG(X)                    [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:X ofType:@"jpg"]]
/// 字符串
#define     IMNoNilString(str)          (str.length > 0 ? str : @"")
/// 方法名
#define     IMStirngFormSelector(s)     [[NSString alloc] initWithUTF8String:sel_getName(s)]
#define     IMStirngFormat(fmt,...)     [NSString stringWithFormat:(fmt), ##__VA_ARGS__]

/// 颜色
#define     RGBColor(r, g, b)           [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0]
#define     RGBAColor(r, g, b, a)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]
#define     HexColor(color)             [UIColor colorWithRed:((float)((color & 0xFF0000) >> 16))/255.0 green:((float)((color & 0xFF00) >> 8))/255.0 blue:((float)(color & 0xFF))/255.0 alpha:1.0]
#define     HexAColor(color, a)         [UIColor colorWithRed:((float)((color & 0xFF0000) >> 16))/255.0 green:((float)((color & 0xFF00) >> 8))/255.0 blue:((float)(color & 0xFF))/255.0 alpha:a]

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





// 对于block的弱引用
#define kWeakSelf           __weak __typeof(self)weakSelf = self;


// 获取tmp目录路径
#define kTmpDir      NSTemporaryDirectory()
// 获取Documents目录路径
#define kDocDir      [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]

#define KXINIUID                [[IMAppDefaultUtil sharedInstance] getXiniuID]

// 临时附件路径
#define KAttachmentTempPath     [kTmpDir stringByAppendingPathComponent:@"tempAttach"]


// 是否刷新消息列表
#define KIsRefreshMessageView   [[NSUserDefaults standardUserDefaults] boolForKey:@"isRefreshMessageView"]


#endif /* IMShortcutMacros_h */
