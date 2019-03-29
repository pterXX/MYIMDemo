//
//  IMSettingItemSwitchCell.m
//  IMChat
//
//  Created by 徐世杰 on 2018/3/7.
//  Copyright © 2018年 徐世杰. All rights reserved.
//

#import "IMSettingItemSwitchCell.h"

@interface IMSettingItemSwitchCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UISwitch *switchControl;

@end

@implementation IMSettingItemSwitchCell

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self p_initSettingItemSwitchCellSubviews];
    }
    return self;
}

- (void)setItem:(IMSettingItem *)item
{
    item.showDisclosureIndicator = NO;
    item.disableHighlight = YES;
    [super setItem:item];
    
    [self.titleLabel setText:item.title];
}

#pragma mark - # UI
- (void)p_initSettingItemSwitchCellSubviews
{
    self.titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.right.mas_lessThanOrEqualTo(-80);
    }];
    
    self.switchControl = [[UISwitch alloc] init];
    [self.contentView addSubview:self.switchControl];
    [self.switchControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_lessThanOrEqualTo(-15);
    }];

}
@end
