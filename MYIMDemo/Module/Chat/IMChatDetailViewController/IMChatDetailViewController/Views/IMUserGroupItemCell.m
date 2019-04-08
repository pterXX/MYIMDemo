//
//  IMUserGroupItemCell.m
//  IMChat
//
//  Created by 徐世杰 on 16/3/6.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "IMUserGroupItemCell.h"
#import "IMUser.h"
#import "NSFileManager+IMChat.h"


@interface IMUserGroupItemCell()

@property (nonatomic, strong) UIButton *avatarView;

@property (nonatomic, strong) UILabel *usernameLabel;

@end

@implementation IMUserGroupItemCell

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.avatarView];
        [self.contentView addSubview:self.usernameLabel];
        
        [self p_addMasonry];
    }
    return self;
}

- (void)setUser:(IMUser *)user
{
    _user = user;
    if (user != nil) {
        [self.avatarView sd_setImageWithURL:IMURL(user.avatarURL) forState:UIControlStateNormal placeholderImage:[UIImage imageDefaultHeadPortrait]];
        [self.usernameLabel setText:user.showName];
    }
    else {
        [self.avatarView setImage:[UIImage imageNamed:@"chatdetail_add_member"] forState:UIControlStateNormal];
        [self.avatarView setImage:[UIImage imageNamed:@"chatdetail_add_memberHL"] forState:UIControlStateHighlighted];
        [self.usernameLabel setText:nil];
    }
}

#pragma mark - EventResponse -
- (void)avatarButtonDown
{
    self.clickBlock(self.user);
}

#pragma mark - Private Methods -
- (void)p_addMasonry
{
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(self.avatarView.mas_width);
    }];
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.bottom.mas_equalTo(self.contentView);
        make.left.and.right.mas_lessThanOrEqualTo(self.contentView);
    }];
}

#pragma mark - Getter -
- (UIButton *)avatarView
{
    if (_avatarView == nil) {
        _avatarView = [[UIButton alloc] init];
        [_avatarView.layer setMasksToBounds:YES];
        [_avatarView.layer setCornerRadius:5.0f];
        [_avatarView addTarget:self action:@selector(avatarButtonDown) forControlEvents:UIControlEventTouchUpInside];
    }
    return _avatarView;
}

- (UILabel *)usernameLabel
{
    if (_usernameLabel == nil) {
        _usernameLabel = [[UILabel alloc] init];
        [_usernameLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [_usernameLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _usernameLabel;
}

@end
