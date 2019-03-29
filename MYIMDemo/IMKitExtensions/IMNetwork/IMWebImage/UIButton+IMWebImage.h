//
//  UIButton+IMWebImage.h
//  IMChat
//
//  Created by 徐世杰 on 2017/7/13.
//  Copyright © 2017年 徐世杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+IMWebImage.h"

@interface UIButton (IMWebImage)

- (void)tt_setImageWithURL:(NSURL *)url forState:(UIControlState)state;
- (void)tt_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder;
- (void)tt_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(IMWebImageOptions)options;
- (void)tt_setImageWithURL:(NSURL *)url forState:(UIControlState)state completed:(IMWebImageDownloadCompleteBlock)completedBlock;
- (void)tt_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder completed:(IMWebImageDownloadCompleteBlock)completedBlock;
- (void)tt_setImageWithURL:(NSURL *)url
                  forState:(UIControlState)state
          placeholderImage:(UIImage *)placeholder
                   options:(IMWebImageOptions)options
                 completed:(IMWebImageDownloadCompleteBlock)completedBlock;

- (void)tt_cancelImageLoadForState:(UIControlState)state;

#pragma mark - # BackgroundImage
- (void)tt_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state;
- (void)tt_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder;
- (void)tt_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(IMWebImageOptions)options;
- (void)tt_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state completed:(IMWebImageDownloadCompleteBlock)completedBlock;
- (void)tt_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder completed:(IMWebImageDownloadCompleteBlock)completedBlock;
- (void)tt_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(IMWebImageOptions)options completed:(IMWebImageDownloadCompleteBlock)completedBlock;

- (void)tt_cancelBackgroundImageLoadForState:(UIControlState)state;
@end
