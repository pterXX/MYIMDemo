//
//  IMMessageBaseCell.h
//  IMChat
//
//  Created by 徐世杰 on 16/3/1.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMMessageCellDelegate.h"
#import "IMMessage.h"

@interface IMMessageBaseCell : UITableViewCell

@property (nonatomic, assign) id<IMMessageCellDelegate>delegate;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIButton *avatarButton;

@property (nonatomic, strong) UILabel *usernameLabel;

@property (nonatomic, strong) UIImageView *messageBackgroundView;

@property (nonatomic, strong) IMMessage *message;

/**
 *  更新消息，如果子类不重写，默认调用setMessage方法
 */
- (void)updateMessage:(IMMessage *)message;

@end
