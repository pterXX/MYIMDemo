//
//  IMExpressiontitleView.m
//  IMChat
//
//  Created by 徐世杰 on 2017/7/23.
//  Copyright © 2017年 徐世杰. All rights reserved.
//

#import "IMExpressiontitleView.h"

@interface IMExpressiontitleView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation IMExpressiontitleView

+ (CGFloat)viewHeightByDataModel:(id)dataModel
{
    return 55;
}

- (void)setViewDataModel:(id)dataModel
{
    if (dataModel && [dataModel isKindOfClass:[NSString class]]) {
        [self.titleLabel setText:dataModel];
    }
    else {
        [self.titleLabel setText:nil];
    }
}

#pragma mark - # Public Methods
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        [bgView setBackgroundColor:[UIColor whiteColor]];
        [self setBackgroundView:bgView];
        [self setTintColor:[UIColor whiteColor]];
        
        self.titleLabel = self.contentView.addLabel(1)
        .backgroundColor([UIColor whiteColor])
        .clipsToBounds(YES)
        .font([UIFont systemFontOfSize:17])
        .masonry(^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_lessThanOrEqualTo(-15);
            make.bottom.mas_equalTo(-12);
        })
        .view;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.addSeparator(IMSeparatorPositionBottom).beginAt(15).length(SCREEN_WIDTH - 15);
}

@end
