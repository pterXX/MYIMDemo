//
//  IMImageExpressionDisplayView.m
//  IMChat
//
//  Created by 徐世杰 on 16/3/16.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "IMImageExpressionDisplayView.h"
#import <SDWebImage/UIImage+GIF.h>

#define     WIDTH_TIPS      150
#define     HEIGHT_TIPS     162
#define     WIDTH_CENTER    25
#define     SPACE_IMAGE     16

@interface IMImageExpressionDisplayView ()

@property (nonatomic, strong) UIImageView *bgLeftView;

@property (nonatomic, strong) UIImageView *bgCenterView;

@property (nonatomic, strong) UIImageView *bgRightView;

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation IMImageExpressionDisplayView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:CGRectMake(0, 0, WIDTH_TIPS, HEIGHT_TIPS)]) {
        [self addSubview:self.bgLeftView];
        [self addSubview:self.bgCenterView];
        [self addSubview:self.bgRightView];
        [self addSubview:self.imageView];
        [self p_addMasonry];
    }
    return self;
}

- (void)displayEmoji:(IMExpressionModel *)emoji atRect:(CGRect)rect
{
    [self setRect:rect];
    [self setEmoji:emoji];
}

static NSString *curID;
- (void)setEmoji:(IMExpressionModel *)emoji
{
    if (_emoji == emoji) {
        return;
    }
    _emoji = emoji;
    curID = emoji.eId;
    NSData *data = [NSData dataWithContentsOfFile:emoji.path];
    if (data) {
        [self.imageView setImage:[UIImage sd_animatedGIFWithData:data]];
    }
    else {
        NSString *urlString = [IMExpressionModel expressionDownloadURLWithEid:emoji.eId];
        [self.imageView sd_setImageWithURL:IMURL(emoji.url) completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if ([urlString containsString:curID]) {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    NSData *data = [NSData dataWithContentsOfURL:IMURL(urlString)];
                    if ([urlString containsString:curID]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.imageView setImage:[UIImage sd_animatedGIFWithData:data]];
                        });
                    }
                });
            }
        }];
    }
}

- (void)setRect:(CGRect)rect
{
    self.y = rect.origin.y - self.height + 3;
    CGFloat w = WIDTH_TIPS - WIDTH_CENTER;
    CGFloat centerX = rect.origin.x + rect.size.width / 2;
    if (rect.origin.x + rect.size.width < self.width) {     // 箭头在左边
        self.centerX = centerX + (WIDTH_TIPS - w / 4 - WIDTH_CENTER) / 2 - SPACE_IMAGE;
        [self.bgLeftView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(w / 4);
        }];
    }
    else if (SCREEN_WIDTH - rect.origin.x < self.width) {   // 箭头在右边
        self.centerX = centerX - (WIDTH_TIPS - w / 4 - WIDTH_CENTER) / 2 + SPACE_IMAGE;
        [self.bgLeftView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(w / 4 * 3);
        }];
    }
    else {
        self.centerX = centerX;
        [self.bgLeftView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(w / 2);
        }];
    }
}

#pragma mark - Private Methods -
- (void)p_addMasonry
{
    [self.bgLeftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.bottom.mas_equalTo(self);
    }];
    [self.bgCenterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgLeftView.mas_right);
        make.top.and.bottom.mas_equalTo(self.bgLeftView);
        make.width.mas_equalTo(WIDTH_CENTER);
    }];
    [self.bgRightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgCenterView.mas_right);
        make.top.and.bottom.mas_equalTo(self.bgLeftView);
        make.right.mas_equalTo(self);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset(10);
        make.left.mas_equalTo(self).mas_offset(10);
        make.right.mas_equalTo(self).mas_offset(-10);
        make.height.mas_equalTo(self.imageView.mas_width);
    }];
}

#pragma mark - Getter -
- (UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UIImageView *)bgLeftView
{
    if (_bgLeftView == nil) {
        _bgLeftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"emojiKB_bigTips_left"]];
    }
    return _bgLeftView;
}

- (UIImageView *)bgCenterView
{
    if (_bgCenterView == nil) {
        _bgCenterView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"emojiKB_bigTips_middle"]];
    }
    return _bgCenterView;
}

- (UIImageView *)bgRightView
{
    if (_bgRightView == nil) {
        _bgRightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"emojiKB_bigTips_right"]];
    }
    return _bgRightView;
}


@end
