//
//  UIImageView+IMWebImage.m
//  IMChat
//
//  Created by 徐世杰 on 2017/7/13.
//  Copyright © 2017年 徐世杰. All rights reserved.
//

#import "UIImageView+IMWebImage.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation UIImageView (IMWebImage)

- (void)tt_setImageWithURL:(NSURL *)url
{
    [self tt_setImageWithURL:url completed:nil];
}

- (void)tt_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    [self tt_setImageWithURL:url placeholderImage:placeholder completed:nil];
}

- (void)tt_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(IMWebImageOptions)options
{
    [self tt_setImageWithURL:url placeholderImage:placeholder options:options completed:nil];
}

- (void)tt_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(IMWebImageDownloadCompleteBlock)completedBlock
{
     [self tt_setImageWithURL:url placeholderImage:placeholder options:nil completed:completedBlock];
}

- (void)tt_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(IMWebImageOptions)options completed:(IMWebImageDownloadCompleteBlock)completedBlock
{
    [self tt_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:completedBlock];
}

- (void)tt_setImageWithURL:(NSURL *)url completed:(IMWebImageDownloadCompleteBlock)completedBlock
{
    [self tt_setImageWithURL:url placeholderImage:nil completed:completedBlock];
}

- (void)tt_setImageWithURL:(NSURL *)url options:(IMWebImageOptions)options completed:(IMWebImageDownloadCompleteBlock)completedBlock
{
    [self tt_setImageWithURL:url placeholderImage:nil options:options progress:nil completed:completedBlock];
}

- (void)tt_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(IMWebImageOptions)options progress:(IMWebImageDownloaderProgressBlock)progressBlock completed:(IMWebImageDownloadCompleteBlock)completedBlock
{
    [self sd_setImageWithURL:url placeholderImage:placeholder options:(SDWebImageOptions)options progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        if (progressBlock) {
            progressBlock(receivedSize, expectedSize, nil);
        }
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (completedBlock) {
            completedBlock(image, error, (IMImageCacheType)cacheType, imageURL);
        }
    }];
}

- (void)tt_cancelCurrentImageLoad
{
    [self sd_cancelCurrentImageLoad];
}

@end
