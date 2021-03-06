//
//  IMPictureCarouselViewCell.m
//  IMChat
//
//  Created by 徐世杰 on 16/4/20.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "IMPictureCarouselViewCell.h"

@interface IMPictureCarouselViewCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation IMPictureCarouselViewCell

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
        
        [self p_addMasonry];
    }
    return self;
}

- (void)setModel:(id<IMPictureCarouselProtocol>)model
{
    [self.imageView tt_setImageWithURL:IMURL([model pictureURL])];
}

#pragma mark - # Private Methods
- (void)p_addMasonry
{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
}

#pragma mark - # Getter
- (UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

@end
