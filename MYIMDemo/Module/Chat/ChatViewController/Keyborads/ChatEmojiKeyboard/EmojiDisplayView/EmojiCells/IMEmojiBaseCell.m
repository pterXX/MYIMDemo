//
//  IMEmojiBaseCell.m
//  IMChat
//
//  Created by 徐世杰 on 16/3/9.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "IMEmojiBaseCell.h"

@implementation IMEmojiBaseCell

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
    }
    return self;
}

- (CGRect)displayBaseRect
{
    return self.frame;
}

- (void)setShowHighlightImage:(BOOL)showHighlightImage
{
    if (showHighlightImage) {
        [self.bgView setImage:self.highlightImage];
    }
    else {
        [self.bgView setImage:nil];
    }
}

#pragma mark - Getter -
- (UIImageView *)bgView
{
    if (_bgView == nil) {
        _bgView = [[UIImageView alloc] init];
        [_bgView.layer setMasksToBounds:YES];
        [_bgView.layer setCornerRadius:5.0f];
    }
    return _bgView;
}

@end
