//
//  IMChatMessageDisplayView.h
//  IMChat
//
//  Created by 徐世杰 on 16/3/9.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMChatMessageDisplayViewDelegate.h"
#import "IMChatCellMenuView.h"

#import "IMTextMessage.h"
#import "IMImageMessage.h"
#import "IMExpressionMessage.h"
#import "IMVoiceMessage.h"


@interface IMChatMessageDisplayView : UIView

@property (nonatomic, assign) id<IMChatMessageDisplayViewDelegate>delegate;

@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, strong, readonly) UITableView *tableView;

/// 禁用下拉刷新
@property (nonatomic, assign) BOOL disablePullToRefresh;

/// 禁用长按菜单
@property (nonatomic, assign) BOOL disableLongPressMenu;

@property (nonatomic, strong) IMChatCellMenuView *menuView;


/**
 *  发送消息（在列表展示）
 */
- (void)addMessage:(IMMessage *)message;

/**
 *  删除消息
 */
- (void)deleteMessage:(IMMessage *)message;
- (void)deleteMessage:(IMMessage *)message withAnimation:(BOOL)animation;

/**
 *  更新消息状态
 */
- (void)updateMessage:(IMMessage *)message;
- (void)reloadData;

/**
 *  滚动到底部
 *
 *  @param animation 是否执行动画
 */
- (void)scrollToBottomWithAnimation:(BOOL)animation;

/**
 *  重新加载聊天信息
 */
- (void)resetMessageView;

@end
