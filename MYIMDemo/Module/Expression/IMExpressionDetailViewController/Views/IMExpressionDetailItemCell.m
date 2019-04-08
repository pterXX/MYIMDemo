//
//  IMExpressionDetailItemCell.m
//  IMChat
//
//  Created by 徐世杰 on 16/4/8.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "IMExpressionDetailItemCell.h"
#import <SDWebImage/UIImage+GIF.h>
#import "UIImage+Color.h"

@interface IMExpressionDetailItemCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation IMExpressionDetailItemCell

+ (CGSize)viewSizeByDataModel:(id)dataModel
{
    return CGSizeMake(EXP_DETAIL_CELL_WIDTH, EXP_DETAIL_CELL_WIDTH);
}

- (void)setViewDataModel:(id)dataModel
{
    [self setEmoji:dataModel];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.imageView = self.contentView.addImageView(1)
        .cornerRadius(3.0f)
        .masonry(^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        })
        .view;
    }
    return self;
}

- (void)setEmoji:(IMExpressionModel *)emoji
{
    _emoji = emoji;
    UIImage *image = [UIImage imageNamed:emoji.path];
    if (image) {
        [self.imageView setImage:image];
    }
    else {
        [self.imageView tt_setImageWithURL:IMURL(emoji.url)];
    }
}


@end
