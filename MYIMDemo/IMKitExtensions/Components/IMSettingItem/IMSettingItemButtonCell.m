//
//  IMSettingItemButtonCell.m
//  IMChat
//
//  Created by 李伯坤 on 2018/3/6.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import "IMSettingItemButtonCell.h"

@interface IMSettingItemButtonCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation IMSettingItemButtonCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self.arrowView setHidden:YES];
        
        self.titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.width.mas_lessThanOrEqualTo(self.contentView);
        }];
    }
    return self;
}

- (void)setItem:(IMSettingItem *)item
{
    item.showDisclosureIndicator = NO;
    [super setItem:item];
    
    [self.titleLabel setText:item.title];
}

@end
