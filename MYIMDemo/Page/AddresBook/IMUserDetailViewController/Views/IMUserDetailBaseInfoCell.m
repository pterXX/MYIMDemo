//
//  IMUserDetailBaseInfoCell.m
//  IMChat
//
//  Created by 徐世杰 on 16/2/29.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "IMUserDetailBaseInfoCell.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "IMUser.h"

#define     MINE_SPACE_X        14.0f
#define     MINE_SPACE_Y        12.0f

@interface IMUserDetailBaseInfoCell ()

@property (nonatomic, strong) UIButton *avatarBtn;
@property (nonatomic, strong) UILabel *shownameLabel;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UILabel *nikenameLabel;

@property (nonatomic, copy) id (^eventAction)(NSInteger, id);

@end

@implementation IMUserDetailBaseInfoCell

+ (CGFloat)viewHeightByDataModel:(id)dataModel
{
    return 90.0f;
}

- (void)setViewDataModel:(id)dataModel
{
    [self setUserModel:dataModel];
}

- (void)setViewEventAction:(id (^)(NSInteger, id))eventAction
{
    self.eventAction = eventAction;
}

- (void)viewIndexPath:(NSIndexPath *)indexPath sectionItemCount:(NSInteger)count
{
    if (indexPath.row == 0) {
        self.addSeparator(IMSeparatorPositionTop);
    }
    
    if (indexPath.row == count - 1) {
        self.addSeparator(IMSeparatorPositionBottom);
    }
    else {
        self.addSeparator(IMSeparatorPositionBottom).beginAt(15);
    }
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        [self p_initUI];
    }
    return self;
}

- (void)setUserModel:(IMUser *)userModel
{
    _userModel = userModel;
    if (userModel.avatarPath) {
        [self.avatarBtn setImage:[UIImage imageNamed:userModel.avatarPath] forState:UIControlStateNormal];
    }
    else if(userModel.avatarURL){
        [self.avatarBtn sd_setBackgroundImageWithURL:IMURL(userModel.avatarURL) forState:UIControlStateNormal placeholderImage:[UIImage imageDefaultHeadPortrait]];
    }else if (userModel.avatar){
        [self.avatarBtn setImage:userModel.avatar forState:UIControlStateNormal];
    }else{
         [self.avatarBtn setImage:[UIImage imageDefaultHeadPortrait] forState:UIControlStateNormal];
    }
    [self.shownameLabel setText:userModel.showName];
    if (userModel.username.length > 0) {
        [self.usernameLabel setText:[NSString stringWithFormat:@"%@：%@", @"账号", userModel.username]];
        if (userModel.nikeName.length > 0) {
            [self.nikenameLabel setText:[NSString stringWithFormat:@"%@：%@", @"昵称", userModel.nikeName]];
        }
    }
    else if (userModel.nikeName.length > 0){
        [self.nikenameLabel setText:[NSString stringWithFormat:@"%@：%@",@"昵称", userModel.nikeName]];
    }
}

#pragma mark - # UI
- (void)p_initUI
{
    @weakify(self);
    
    // 头像
    self.avatarBtn = [[UIButton alloc] init];
    self.avatarBtn.layer.cornerRadius = 5;
    self.avatarBtn.layer.masksToBounds = YES;
    [self.contentView addSubview:self.avatarBtn];
    [self.avatarBtn addIMClickAction:^(UIButton *button) {
        @strongify(self);
        if (self.eventAction) {
            self.eventAction(0, self.userModel);
        }
    }];
    [self.avatarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.top.mas_equalTo(12);
        make.bottom.mas_equalTo(-12);
        make.width.mas_equalTo(self.avatarBtn.mas_height);
    }];
    
    // 用户昵称
    self.shownameLabel = [[UILabel alloc] init];
    self.shownameLabel.font = [UIFont systemFontOfSize:17.0];
    [self.contentView addSubview:self.shownameLabel];
    [self.shownameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatarBtn.mas_right).mas_offset(MINE_SPACE_Y);
        make.top.mas_equalTo(self.avatarBtn.mas_top).mas_offset(3);
    }];
    [self.shownameLabel setContentCompressionResistancePriority:100 forAxis:UILayoutConstraintAxisHorizontal];
    
    // 用户名
    self.usernameLabel = [[UILabel alloc] init];
    self.usernameLabel.font = [UIFont systemFontOfSize:14.0f];
    self.usernameLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.usernameLabel];
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.shownameLabel);
        make.top.mas_equalTo(self.shownameLabel.mas_bottom).mas_offset(5);
    }];
    
    // 昵称
    self.nikenameLabel = [[UILabel alloc] init];
    self.nikenameLabel.font = [UIFont systemFontOfSize:14.0f];
    self.nikenameLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.nikenameLabel];
    [self.nikenameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.shownameLabel);
        make.top.mas_equalTo(self.usernameLabel.mas_bottom).mas_offset(3);
    }];
}

@end
