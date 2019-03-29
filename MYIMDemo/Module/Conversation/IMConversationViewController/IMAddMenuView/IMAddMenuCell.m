//
//  IMAddMenuCell.m
//  IMChat
//
//  Created by 徐世杰 on 16/3/11.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "IMAddMenuCell.h"

@interface IMAddMenuCell()

@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation IMAddMenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setBackgroundColor:[UIColor colorBlackForAddMenu]];
        UIView *selectedView = [[UIView alloc] init];
        [selectedView setBackgroundColor:[UIColor colorBlackForAddMenuHL]];
        [self setSelectedBackgroundView:selectedView];
    
        [self p_initUI];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.addSeparator(IMSeparatorPositionBottom).beginAt(15).endAt(-15).color([UIColor colorGrayLine]);
}

- (void)setItem:(IMAddMenuItem *)item
{
    _item = item;
    [self.iconView setImage:[UIImage imageNamed:item.iconPath]];
    [self.titleLabel setText:item.title];
}

#pragma mark - Private Methods
- (void)p_initUI
{
    self.iconView = self.contentView.addImageView(1).view;
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).mas_offset(15.0f);
        make.centerY.mas_equalTo(self);
        make.height.and.width.mas_equalTo(32);
    }];
    
    self.titleLabel = self.contentView.addLabel(2)
    .font([UIFont systemFontOfSize:16.0f])
    .textColor([UIColor whiteColor])
    .view;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right).mas_offset(10.0f);
        make.centerY.mas_equalTo(self.iconView);
    }];
}

@end
