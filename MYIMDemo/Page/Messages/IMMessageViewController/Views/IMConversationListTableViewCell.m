//
//  IMMessagesListTableViewCell.m
//  KXiniuCloud
//
//  Created by RPK on 2018/4/17.
//  Copyright © 2018年 EIMS. All rights reserved.
//

#import "IMConversationListTableViewCell.h"


#import "IMMessageModel.h"
#import "NSDate+Category.h"
#import "IMConversationModel.h"
#import "UILabel+AutoLabelHeightAndWidth.h"

@interface IMConversationListTableViewCell ()

@end

@implementation IMConversationListTableViewCell
#pragma mark - # Cell
+ (CGFloat)viewHeightByDataModel:(id)dataModel{
    return 70.0f;
}

- (void)setViewDataModel:(id)dataModel{
    [self setConversation:dataModel];
}

- (void)viewIndexPath:(NSIndexPath *)indexPath sectionItemCount:(NSInteger)count{
    if (indexPath.row == count - 1) {
        self.removeSeparator(SeparatorPositionBottom);
    }
    else {
        self.addSeparator(SeparatorPositionBottom).beginAt(10);
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    
    _avaterImageView                   = [UIImageView new];
    CGRect rect                        = CGRectMake(0, 0, 50, 50);
    [self addSubview:_avaterImageView];
    //  绘制圆角
    layoutRoundCorner(_avaterImageView, rect, 5);
    [_avaterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.left.mas_offset(10);
        make.size.mas_equalTo(rect.size);
    }];

    _updateTime                        = [UILabel new];
    _updateTime.textColor              = [UIColor lightGrayColor];
    _updateTime.font                   = [UIFont systemFontOfSize:12];
    _updateTime.textAlignment          = NSTextAlignmentRight;
    [self addSubview:_updateTime];
    [_updateTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(17);
        make.right.mas_offset(-10);
        make.size.mas_equalTo(CGSizeMake(0, 14));
    }];

    _titleLabel                        = [UILabel new];
    _titleLabel.font                   = [UIFont systemFontOfSize:16];
    _titleLabel.textColor              = [UIColor blackColor];
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(14);
        make.left.equalTo(_avaterImageView.mas_right).offset(10);
        make.right.equalTo(_updateTime.mas_left).offset(-10);
        make.height.mas_equalTo(20);
    }];

    _badgeNumber                       = [UILabel new];
    _badgeNumber.layer.cornerRadius    = 9;
    _badgeNumber.layer.masksToBounds   = YES;
    _badgeNumber.layer.backgroundColor = [UIColor redColor].CGColor;
    _badgeNumber.textColor             = [UIColor whiteColor];
    _badgeNumber.textAlignment         = NSTextAlignmentCenter;
    _badgeNumber.font                  = [UIFont systemFontOfSize:12];
    [self addSubview:_badgeNumber];
    [_badgeNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_avaterImageView.mas_top).mas_offset(-9);
        make.right.equalTo(_avaterImageView.mas_right).offset(-9);
        make.height.mas_equalTo(18);
        make.width.mas_equalTo(0);
    }];

    _messageLabel                      = [UILabel new];
    _messageLabel.font                 = [UIFont systemFontOfSize:14];
    _messageLabel.textColor            = [UIColor lightGrayColor];
    [self addSubview:_messageLabel];
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).mas_offset(6);
        make.left.equalTo(_titleLabel);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(18);
    }];
}

- (void)setConversation:(IMConversationModel *)conversation{
    if (!conversation.headImage || conversation.headImage.length == 0)
    {
       [_avaterImageView setImage:[KIMXMPPHelper userAvatarForJid:conversation.chatToJid]];
    }
    else if ([conversation.headImage containsString:@"storage/headImage"]) {
        NSString *imagePath = [NSFileManager pathUserSettingImage:conversation.headImage];
        _avaterImageView.image = [UIImage imageWithContentsOfFile:imagePath];
    }
    else if ([conversation.headImage containsString:@"http://"] || [conversation.headImage containsString:@"https://"])
    {
        [_avaterImageView sd_setImageWithURL:[NSURL URLWithString:conversation.headImage]];
    }

    _titleLabel.text = conversation.conversationName;
    if ((!conversation.conversationName || conversation.conversationName.length == 0) && [conversation.chatToJid.user isEqualToString:[IMXMPPHelper sharedHelper].myJID.user]) {
        _titleLabel.text = [[IMAppDefaultUtil sharedInstance] getUserName];
    }
    
    _messageLabel.text = conversation.message.content;
    if (conversation.message.messageSendStatus == IMMessageSendStatusSendFailure && conversation.message.recvTime.length) {
        _messageLabel.text = @"";
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
        NSTextAttachment *textAttach = [[NSTextAttachment alloc] init];
        textAttach.image = [UIImage imageMessageSendFailure];
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
    [_updateTime mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(timeWidth);
    }];
    
    if (conversation.badgeNumber == 0){
        _badgeNumber.text = @"";
        [_badgeNumber mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
    }
    else{
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
        [_badgeNumber mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(badgeWidth);
        }];
    }
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
