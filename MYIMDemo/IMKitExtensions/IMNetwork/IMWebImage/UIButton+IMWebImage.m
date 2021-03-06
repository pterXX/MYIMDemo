//
//  UIButton+IMWebImage.m
//  IMChat
//
//  Created by 徐世杰 on 2017/7/13.
//  Copyright © 2017年 徐世杰. All rights reserved.
//

#import "UIButton+IMWebImage.h"
#import <SDWebImage/UIButton+WebCache.h>

@implementation UIButton (IMWebImage)

- (void)tt_setImageWithURL:(NSURL *)url forState:(UIControlState)state
{
    [self tt_setImageWithURL:url forState:state placeholderImage:nil];
}

- (void)tt_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder
{
    [self tt_setImageWithURL:url forState:state placeholderImage:placeholder completed:nil];
}

- (void)tt_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(IMWebImageOptions)options
{
    [self tt_setImageWithURL:url forState:state placeholderImage:placeholder options:options completed:nil];
}

- (void)tt_setImageWithURL:(NSURL *)url forState:(UIControlState)state completed:(IMWebImageDownloadCompleteBlock)completedBlock
{
    [self tt_setImageWithURL:url forState:state placeholderImage:nil completed:completedBlock];
}

- (void)tt_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder completed:(IMWebImageDownloadCompleteBlock)completedBlock
{
    [self tt_setImageWithURL:url forState:state placeholderImage:placeholder options:IMWebImageRetryFailed completed:completedBlock];
}

- (void)tt_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(IMWebImageOptions)options completed:(IMWebImageDownloadCompleteBlock)completedBlock
{
    [self sd_setImageWithURL:url forState:state placeholderImage:placeholder options:(SDWebImageOptions)options completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (completedBlock) {
            completedBlock(image, error, (IMImageCacheType)cacheType, imageURL);
        }
    }];
}

- (void)tt_cancelImageLoadForState:(UIControlState)state
{
    [self sd_cancelImageLoadForState:state];
}

#pragma mark - # BackgroundImage

- (void)tt_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state
{
    [self tt_setBackgroundImageWithURL:url forState:state placeholderImage:nil options:0 completed:nil];
}

- (void)tt_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder
{
    [self tt_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:nil];
}

- (void)tt_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(IMWebImageOptions)options
{
    [self tt_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:options completed:nil];
}

- (void)tt_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state completed:(IMWebImageDownloadCompleteBlock)completedBlock
{
    [self tt_setBackgroundImageWithURL:url forState:state placeholderImage:nil options:0 completed:completedBlock];
}

- (void)tt_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder completed:(IMWebImageDownloadCompleteBlock)completedBlock
{
    [self tt_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:completedBlock];
}

- (void)tt_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(IMWebImageOptions)options completed:(IMWebImageDownloadCompleteBlock)completedBlock
{
    [self sd_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:(SDWebImageOptions)options completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (completedBlock) {
            completedBlock(image, error, (IMImageCacheType)cacheType, imageURL);
        }
    }];
}

- (void)tt_cancelBackgroundImageLoadForState:(UIControlState)state
{
    [self sd_cancelBackgroundImageLoadForState:state];
}

@end
