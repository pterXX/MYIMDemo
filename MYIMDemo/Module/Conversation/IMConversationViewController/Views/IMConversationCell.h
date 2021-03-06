//
//  IMConversationCell.h
//  IMChat
//
//  Created by 徐世杰 on 16/1/23.
//  Copyright © 2016年 徐世杰. All rights reserved.

#import <UIKit/UIKit.h>
#import "IMConversation.h"

#define     HEIGHT_CONVERSATION_CELL        64.0f

typedef NS_ENUM(NSInteger, IMConversationCellSeperatorStyle) {
    IMConversationCellSeperatorStyleDefault,
    IMConversationCellSeperatorStyleFill,
};

@interface IMConversationCell : UITableViewCell <IMFlexibleLayoutViewProtocol>

/// 会话Model
@property (nonatomic, strong) IMConversation *conversation;

@property (nonatomic, assign) IMConversationCellSeperatorStyle bottomSeperatorStyle;

/**
 *  标记为未读
 */
- (void)markAsUnread;

/**
 *  标记为已读
 */
- (void)markAsRead;

@end
