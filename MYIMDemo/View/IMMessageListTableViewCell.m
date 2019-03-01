//
//  IMMessageListTableViewCell.m
//  MYIMDemo
//
//  Created by 徐世杰 on 2019/3/1.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "IMMessageListTableViewCell.h"

@implementation IMMessageListTableViewCell

- (void)im_addSubViews{
    _avaterImageView                   = [UIImageView new];
    CGRect rect                        = CGRectMake(0, 0, 50, 50);
    // 贝塞尔曲线绘制圆角
    UIBezierPath *maskPath             = [UIBezierPath bezierPathWithRoundedRect:rect  byRoundingCorners:UIRectCornerAllCorners  cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer            = [CAShapeLayer layer];
    maskLayer.path                     = maskPath.CGPath;
    _avaterImageView.layer.mask        = maskLayer;
    [self addSubview:_avaterImageView];
    
    _avaterImageView.sd_layout.topSpaceToView(self, 10).leftSpaceToView(self, 10).widthIs(50).heightEqualToWidth();
    
    _updateTime                        = [UILabel new];
    _updateTime.textColor              = [UIColor colorTextlightGrayColor];
    _updateTime.font                   = [UIFont fontMessageListUpdateTime];
    _updateTime.textAlignment          = NSTextAlignmentRight;
    [self addSubview:_updateTime];
    
    _updateTime.sd_layout.topSpaceToView(self, 17).rightSpaceToView(self, 10).heightIs(14).widthIs(0);
    
    _titleLabel                        = [UILabel new];
    _titleLabel.font                   = [UIFont fontMessageListTitle];
    _titleLabel.textColor              = [UIColor colorTextBlack];
    [self addSubview:_titleLabel];
    
    _titleLabel.sd_layout.topSpaceToView(self, 14).leftSpaceToView(_avaterImageView, 10).rightSpaceToView(_updateTime, 10).heightIs(20);
    
    _badgeNumber                       = [UILabel new];
    _badgeNumber.layer.cornerRadius    = 9;
    _badgeNumber.layer.masksToBounds   = YES;
    _badgeNumber.layer.backgroundColor = [UIColor redColor].CGColor;
    _badgeNumber.textColor             = [UIColor whiteColor];
    _badgeNumber.textAlignment         = NSTextAlignmentCenter;
    _badgeNumber.font                  = [UIFont fontMessageListBadgeNumber];
    [self addSubview:_badgeNumber];
    
    _badgeNumber.sd_layout.topSpaceToView(_titleLabel, 6).rightSpaceToView(self, 10).heightIs(18).widthIs(0);
    
    _messageLabel                      = [UILabel new];
    _messageLabel.font                 = [UIFont fontNavBarTitle];
    _messageLabel.textColor            = [UIColor colorTextlightGrayColor];
    [self addSubview:_messageLabel];
    
    _messageLabel.sd_layout.topSpaceToView(_titleLabel, 6).leftSpaceToView(_avaterImageView, 10).rightSpaceToView(_badgeNumber, 20).heightIs(18);
}

- (void)setConversation:(IMConversationModel *)conversation
{
    
    if (conversation.chatType == IMMessageChatTypeFTP)
    {
        _avaterImageView.image = [UIImage imageNamed:@"helper"];
    }
    else
    {
        if (!conversation.headImage || conversation.headImage.length == 0)
        {
            _avaterImageView.image = [UIImage imageDefaultHeadPortrait];
        }
        else if ([conversation.headImage containsString:@"storage/headImage"]) {
            NSString *imagePath = [kDocDir stringByAppendingPathComponent:conversation.headImage];
            _avaterImageView.image = [UIImage imageWithContentsOfFile:imagePath];
        }
        else if ([conversation.headImage containsString:@"http://"] || [conversation.headImage containsString:@"https://"])
        {
            [_avaterImageView sd_setImageWithURL:[NSURL URLWithString:conversation.headImage]];
        }
    }
    
    _titleLabel.text = conversation.conversationName;
    if ((!conversation.conversationName || conversation.conversationName.length == 0) && [conversation.toUserId isEqualToString:KXINIUID]) {
        _titleLabel.text = [[IMAppDefaultUtil sharedInstance] getUserName];
    }
    
    _messageLabel.text = conversation.message.content;
    if (conversation.message.messageSendStatus == IMMessageSendStatusSendFailure && conversation.message.recvTime.length) {
        _messageLabel.text = @"";
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
        
        NSTextAttachment *textAttach = [[NSTextAttachment alloc] init];
        textAttach.image = [UIImage imageNamed:@"icon_message_send_failure"];
        textAttach.bounds = CGRectMake(0, -2, 16, 16);
        NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttach];
        [attributedString appendAttributedString:imageStr];
        // 内容前面加两个空格
        NSString *content = [NSString stringWithFormat:@" %@",conversation.message.content];
        [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:content]];
        _messageLabel.attributedText = attributedString;
    }
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSInteger timeInterval = [conversation.message.recvTime integerValue];
    _updateTime.text   = [NSDate conversationTimeWithRecvTime:timeInterval];
    
    CGFloat timeWidth  = [UILabel getWidthWithTitle:_updateTime.text
                                               font:_updateTime.font];
    _updateTime.sd_layout.widthIs(timeWidth);
    
    if (conversation.badgeNumber == 0)
    {
        _badgeNumber.text = @"";
        _badgeNumber.sd_layout.widthIs(0);
    }
    else
    {
        NSString *unreadNum = @"";
        if (conversation.badgeNumber <= 99)
        {
            unreadNum = [NSString stringWithFormat:@"%d", conversation.badgeNumber];
        }
        else
        {
            unreadNum = @"...";
        }
        _badgeNumber.text  = unreadNum;
        CGFloat badgeWidth = [UILabel getWidthWithTitle:_badgeNumber.text font:_badgeNumber.font];
        badgeWidth = badgeWidth > 18 ? badgeWidth : 18;
        _badgeNumber.sd_layout.widthIs(badgeWidth);
    }
    [_badgeNumber updateLayout];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
