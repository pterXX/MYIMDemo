//
//  IMSettingSectionHeaderView.m
//  IMChat
//
//  Created by 徐世杰 on 2018/3/6.
//  Copyright © 2018年 徐世杰. All rights reserved.
//

#import "IMSettingSectionHeaderView.h"

#define     FONT_SETTING_SECTION        [UIFont systemFontOfSize:14.0f]

@interface IMSettingSectionHeaderView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation IMSettingSectionHeaderView

#pragma mark - # Protocol
+ (CGFloat)viewHeightByDataModel:(NSString *)dataModel
{
    CGFloat textHeight = [dataModel kk_SizeWithFont:FONT_SETTING_SECTION constrainedToWidth:SCREEN_WIDTH - 30].height;
    return textHeight + 20;
}

- (void)setViewDataModel:(id)dataModel
{
    [self.titleLabel setText:dataModel];
}

#pragma mark - # View
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textColor = [UIColor grayColor];
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.bottom.mas_equalTo(-6);
        }];
    }
    return self;
}

@end
