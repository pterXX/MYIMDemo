//
//  IMTextMessageCell.m
//  IMChat
//
//  Created by 李伯坤 on 16/3/1.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "IMTextMessageCell.h"

#define     MSG_SPACE_TOP       14
#define     MSG_SPACE_BTM       20
#define     MSG_SPACE_LEFT      19
#define     MSG_SPACE_RIGHT     22

@interface IMTextMessageCell ()

@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation IMTextMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.messageLabel];
    }
    return self;
}

- (void)setMessage:(IMTextMessage *)message
{
    if (self.message && [self.message.messageID isEqualToString:message.messageID]) {
        return;
    }
    IMMessageOwnerType lastOwnType = self.message ? self.message.ownerTyper : -1;
    [super setMessage:message];
    [self.messageLabel setAttributedText:[message attrText]];
    
    [self.messageLabel setContentCompressionResistancePriority:500 forAxis:UILayoutConstraintAxisHorizontal];
    [self.messageBackgroundView setContentCompressionResistancePriority:100 forAxis:UILayoutConstraintAxisHorizontal];
    if (lastOwnType != message.ownerTyper) {
        if (message.ownerTyper == IMMessageOwnerTypeSelf) {
            [self.messageBackgroundView setImage:[UIImage imageNamed:@"message_sender_bg"]];
            [self.messageBackgroundView setHighlightedImage:[UIImage imageNamed:@"message_sender_bgHL"]];
            
            [self.messageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.messageBackgroundView).mas_offset(-MSG_SPACE_RIGHT);
                make.top.mas_equalTo(self.messageBackgroundView).mas_offset(MSG_SPACE_TOP);
            }];
            [self.messageBackgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.messageLabel).mas_offset(-MSG_SPACE_LEFT);
                make.bottom.mas_equalTo(self.messageLabel).mas_offset(MSG_SPACE_BTM);
            }];
        }
        else if (message.ownerTyper == IMMessageOwnerTypeFriend){
            [self.messageBackgroundView setImage:[UIImage imageNamed:@"message_receiver_bg"]];
            [self.messageBackgroundView setHighlightedImage:[UIImage imageNamed:@"message_receiver_bgHL"]];
            
            [self.messageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.messageBackgroundView).mas_offset(MSG_SPACE_LEFT);
                make.top.mas_equalTo(self.messageBackgroundView).mas_offset(MSG_SPACE_TOP);
            }];
            [self.messageBackgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.messageLabel).mas_offset(MSG_SPACE_RIGHT);
                make.bottom.mas_equalTo(self.messageLabel).mas_offset(MSG_SPACE_BTM);
            }];
        }
    }
    
    [self.messageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(message.messageFrame.contentSize);
    }];
}

#pragma mark - Getter -
- (UILabel *)messageLabel
{
    if (_messageLabel == nil) {
        _messageLabel = [[UILabel alloc] init];
        [_messageLabel setFont:[UIFont fontTextMessageText]];
        [_messageLabel setNumberOfLines:0];
    }
    return _messageLabel;
}

@end
