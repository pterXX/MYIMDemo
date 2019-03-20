//
//  IMChatTableViewCell.m
//  KXiniuCloud
//
//  Created by eims on 2018/4/25.
//  Copyright © 2018年 EIMS. All rights reserved.
//

#import "IMChatTableViewCell.h"

#import "NSDate+Category.h"
#import "NSDictionary+Json.h"
#import "UIImage+Compression.h"

#import "IMMessageModel.h"
#import "IMConversationModel.h"


@implementation IMChatTableViewCell

/**
 消息时间
 */
- (UILabel *)messageTime
{
    if (!_messageTime) {
        _messageTime                 = [[UILabel alloc] initWithFrame:CGRectZero];
        _messageTime.textColor       = [UIColor whiteColor];
        _messageTime.font            = [UIFont systemFontOfSize:12];
        _messageTime.textAlignment   = NSTextAlignmentCenter;
        _messageTime.backgroundColor = [IMColorTools colorWithHexString:@"0xcbcbcb"];
        _messageTime.hidden          = YES;
    }
    
    return _messageTime;
}

/**
 username 用户名
 */
- (UILabel *)username
{
    if (_username == nil)
    {
        _username = [[UILabel alloc] initWithFrame:CGRectZero];
        _username.font = [UIFont systemFontOfSize:MESSAGE_NICKNAME_FONT];
        _username.textColor = USERNAME_TEXTCOLOR;
        [_username setHidden:YES];
    }
    
    return _username;
}

/**
 * avatarImageView 头像
 */
- (UIImageView *)avatarImageView
{
    if (_avatarImageView == nil)
    {
        _avatarImageView                        = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, AVATAR_WIDTH, AVATAR_WIDTH)];
        [_avatarImageView setHidden:YES];
        UIBezierPath *maskPath                  = [UIBezierPath bezierPathWithRoundedRect:_avatarImageView.bounds  byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer *maskLayer                 = [CAShapeLayer layer];
        maskLayer.path                          = maskPath.CGPath;
        _avatarImageView.layer.mask             = maskLayer;
        _avatarImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUserAvatarImageView:)];
        [_avatarImageView addGestureRecognizer:tap];
    }
    
    return _avatarImageView;
}

/**
 *  聊天背景图
 */
- (UIImageView *)messageBackgroundImageView
{
    if (_messageBackgroundImageView == nil)
    {
        _messageBackgroundImageView = [[UIImageView alloc] init];
        [_messageBackgroundImageView setHidden:YES];
        _messageBackgroundImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clicIMMessageBackgroundImageView:)];
        [_messageBackgroundImageView addGestureRecognizer:tap];
    }
    
    return _messageBackgroundImageView;
}


/**
 messageSendStatusImageView 显示读取状态
 */
- (UIImageView *)messageSendStatusImageView
{
    if (!_messageSendStatusImageView) {
        _messageSendStatusImageView = [[UIImageView alloc] init];
        _messageSendStatusImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resendAction:)];
        [_messageSendStatusImageView addGestureRecognizer:tap];
    }
    
    return _messageSendStatusImageView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle  = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.messageTime];
        [self addSubview:self.avatarImageView];
        [self addSubview:self.username];
        [self addSubview:self.messageBackgroundImageView];
        [self addSubview:self.messageSendStatusImageView];
    }
    
    return self;
}

- (void)setMessageModel:(IMMessageModel *)messageModel
{
    _messageModel           = messageModel;
    if (messageModel.isDelayShowSendStatus) {
        if (messageModel.messageSendStatus == IMMessageSendStatusSending) {

            kWeakSelf
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                //执行事件
                [weakSelf updateMessageSendState:IMMessageSendStatusSending jsonStr:nil localMessageId:messageModel.messageId];
                
            });
        }
        else {
            [self updateMessageSendState:messageModel.messageSendStatus jsonStr:nil localMessageId:messageModel.messageId];
        }
    }
    else {
        [self updateMessageSendState:messageModel.messageSendStatus jsonStr:nil localMessageId:messageModel.messageId];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (messageModel.aotoResend) {
            [self resendMessage];
        }
    });
    
    [self.messageTime setHidden:!messageModel.showMessageTime];
    
    switch (messageModel.direction)
    {
        case IMMessageSenderTypeSender:
        {
            [self.avatarImageView setHidden:NO];
            [self.avatarImageView setImage:[KIMXMPPHelper myAvatar]];
            [self.messageBackgroundImageView setHidden:NO];
            // 聊天背景拉伸
            // UIImageResizingModeStretch：拉伸模式，通过拉伸UIEdgeInsets指定的矩形区域来填充图片
            // UIImageResizingModeTile：平铺模式，通过重复显示UIEdgeInsets指定 的矩形区域来填充图片
            self.messageBackgroundImageView.image = [[UIImage imageSenderMessageBackground] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
        }
            break;
        case IMMessageSenderTypeReceiver:
        {
            [self.avatarImageView setHidden:NO];
            self.messageSendStatusImageView.image = nil;
            NSLog(@"jid -> %@",messageModel.msgJid);
            [self.avatarImageView im_setAvatar:messageModel.toUserAvatar jid:messageModel.msgJid];
            
            [self.messageBackgroundImageView setHidden:NO];
            // 聊天背景拉伸
            self.messageBackgroundImageView.image = [[UIImage imageReceiverMessageBackground] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 15) resizingMode:UIImageResizingModeStretch];
            
            [self.username setHidden:!self.messageModel.showUsername];
            NSAttributedString *usernameAtt = [[NSAttributedString alloc] initWithString:self.messageModel.toUserName ? self.messageModel.toUserName: @""];
            [self.username setAttributedText:usernameAtt];
        }
            break;
            
        default:
            break;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_messageModel.showMessageTime)
    {
        NSInteger timeInterval = 0;
        if (_messageModel.direction == IMMessageSenderTypeSender) {
            timeInterval = [_messageModel.sendTime integerValue];
        }else {
            timeInterval = [_messageModel.recvTime integerValue];
        }
        
        if (timeInterval > 0) {
            self.messageTime.text  = [NSDate messageTimeWithRecvTime:timeInterval];
        }
        CGSize messageTimeSize = [self.messageTime sizeThatFits:CGSizeMake(MESSAGE_MAX_WIDTH, MAXFLOAT)];
        self.messageTime.frame = CGRectMake(self.mj_w/2. - messageTimeSize.width/2. - 10, MESSAGE_BACKGROUND_SPACE, messageTimeSize.width + 20, 20);
        // 设置圆角
        UIBezierPath *bezierPath     = [UIBezierPath bezierPathWithRoundedRect:self.messageTime.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer *maskLayer      = [CAShapeLayer layer];
        maskLayer.path               = bezierPath.CGPath;
        self.messageTime.layer.mask  = maskLayer;
    }
    else
    {
        self.messageTime.frame = CGRectMake(self.mj_w/2., 0, 0, 0);
    }
    
    if (_messageModel.direction == IMMessageSenderTypeReceiver)
    {
        [self.avatarImageView setFrame:CGRectMake(AVATAR_SCREEN_SPACE, self.messageTime.mj_y + self.messageTime.mj_h + AVATAR_SCREEN_SPACE, AVATAR_WIDTH, AVATAR_WIDTH)];
        
        if (_messageModel.showUsername)
        {
            CGSize userNameSize = [self.username sizeThatFits:CGSizeMake(MESSAGE_MAX_WIDTH - 2*MESSAGE_BACKGROUND_SPACE, MAXFLOAT)];
            [self.username setFrame:CGRectMake(AVATAR_SCREEN_SPACE + AVATAR_WIDTH + AVATAR_USERNAME_SPACE, self.avatarImageView.mj_y, userNameSize.width, USERNAME_HEIGHT - 2)];
        }
        else
        {
            [self.username setFrame:CGRectMake(AVATAR_SCREEN_SPACE + AVATAR_WIDTH + AVATAR_USERNAME_SPACE, self.avatarImageView.mj_y, 0, 0)];
        }
    }
    else
    {
        // IMSCREEN_WIDTH(屏幕宽) - AVATAR_SCREEN_SPACE(头像与屏幕的间隔) - AVATAR_WIDTH(头像宽)
        [self.avatarImageView setFrame:CGRectMake(IMSCREEN_WIDTH - AVATAR_SCREEN_SPACE - AVATAR_WIDTH, self.messageTime.mj_y + self.messageTime.mj_h + AVATAR_SCREEN_SPACE, AVATAR_WIDTH, AVATAR_WIDTH)];
        [self.username setFrame:CGRectMake(self.avatarImageView.mj_x - MESSAGE_BACKGROUND_SPACE, self.avatarImageView.mj_y, 0, 0)];
    }
    
}

// 点击头像
- (void)clickUserAvatarImageView:(UITapGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatTableViewCell:clickAvatarImageViewMessageModel:)])
    {
        [self.delegate chatTableViewCell:self clickAvatarImageViewMessageModel:self.messageModel];
    }
}

// 点击消息
- (void)clicIMMessageBackgroundImageView:(UITapGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatTableViewCell:clickBackgroudImageViewMessageModel:)])
    {
        [self.delegate chatTableViewCell:self clickBackgroudImageViewMessageModel:self.messageModel];
    }
}

- (void)resendAction:(UITapGestureRecognizer *)gesture {
    UIImageView *imageView = (UIImageView *)[gesture view];
    if (imageView.image && _messageModel.messageSendStatus == IMMessageSendStatusSendFailure) {
        
        [self resendMessage];
    }
}

/**
 更新消息发送状态
 
 @param sendState 发送状态
 @param jsonStr 发送的json数据
 @param messageId 本地消息id
 */
- (void)updateMessageSendState:(IMMessageSendStatus)sendState jsonStr:(NSString *)jsonStr localMessageId:(NSString *)messageId {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.jsonStr = jsonStr;
        self.localMessageId = messageId;
        self.messageSendStatusImageView.hidden = sendState == IMMessageSendStatusSendSuccess;
        UIImage *image = nil;
        if (self.messageModel.direction == IMMessageSenderTypeReceiver) {
            self.messageSendStatusImageView.image = image;
            return;
        }
        CABasicAnimation *rotationAnimation;
        if (sendState == IMMessageSendStatusSending) {
            rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            rotationAnimation.toValue     = [NSNumber numberWithFloat: M_PI * 2.0 ];
            rotationAnimation.duration    = 0.8;
            rotationAnimation.cumulative  = YES;
            rotationAnimation.repeatCount = 10000;
            
            image = [UIImage imageMessageSending];
            self.messageSendStatusImageView.image = image;
            [self.messageSendStatusImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];//开始动画
        }
        else if (sendState == IMMessageSendStatusSendFailure) {
            [self.messageSendStatusImageView.layer removeAnimationForKey:@"rotationAnimation"];//结束动画
            image = [UIImage imageMessageSendFailure];
            self.messageSendStatusImageView.image = image;
        }
        else {
            [self.messageSendStatusImageView.layer removeAnimationForKey:@"rotationAnimation"];//结束动画
            self.messageSendStatusImageView.image = nil;
        }
    });
}

- (void)resendMessage {
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatTableViewCell:clickResendMessageWithConversationModel:messageModel:)]) {
        [self.delegate chatTableViewCell:self clickResendMessageWithConversationModel:_conversation messageModel:_messageModel];
    }
}

@end
