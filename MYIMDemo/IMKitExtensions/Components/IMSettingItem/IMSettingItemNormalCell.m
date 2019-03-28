//
//  IMSettingItemNormalCell.m
//  IMChat
//
//  Created by 李伯坤 on 2018/3/5.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import "IMSettingItemNormalCell.h"

@interface IMSettingItemNormalCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *rightLabel;

@property (nonatomic, strong) UIImageView *rightImageView;

@end

@implementation IMSettingItemNormalCell

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self p_initSettingItemSubviews];
    }
    return self;
}

- (void)setItem:(IMSettingItem *)item
{
    [super setItem:item];
    
    [self.titleLabel setText:item.title];
    [self.rightLabel setText:item.subtitle];
    if (item.rightImagePath) {
        [self.rightImageView setImage: [UIImage imageNamed:item.rightImagePath]];
    }
    else if (item.rightImageURL){
        [self.rightImageView tt_setImageWithURL:IMURL(item.rightImageURL) placeholderImage:[UIImage imageDefaultHeadPortrait]];
    }
    else {
        [self.rightImageView setImage:nil];
    }

    [self.rightLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(item.showDisclosureIndicator ? -30.0f : -15.0f);
    }];
}

#pragma mark - # UI
- (void)p_initSettingItemSubviews
{
    
    self.titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(15);
    }];
    
    self.rightLabel = [[UILabel alloc] init];
    self.rightLabel.textColor = [UIColor grayColor];
    self.rightLabel.font = [UIFont systemFontOfSize:15.0f];
    [self.contentView addSubview:self.rightLabel];
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-30);
        make.centerY.mas_equalTo(self.titleLabel);
        make.left.mas_greaterThanOrEqualTo(self.titleLabel.mas_right).mas_offset(20);
    }];
    
    self.rightImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.rightImageView];
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.rightLabel.mas_left).mas_offset(-2);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.titleLabel setContentCompressionResistancePriority:500 forAxis:UILayoutConstraintAxisHorizontal];
    [self.rightLabel setContentCompressionResistancePriority:200 forAxis:UILayoutConstraintAxisHorizontal];
}


@end
