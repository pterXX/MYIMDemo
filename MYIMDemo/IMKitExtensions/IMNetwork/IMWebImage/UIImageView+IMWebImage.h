//
//  UIImageView+IMWebImage.h
//  IMChat
//
//  Created by 徐世杰 on 2017/7/13.
//  Copyright © 2017年 徐世杰. All rights reserved.
//
//  网络图片拓展，基于SDWebImage
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, IMWebImageOptions) {
    /**
     * 失败重试（默认）
     */
    IMWebImageRetryFailed = 1 << 0,
    /**
     * 低优先级的（在scrollView滑动时不下载，减速时开始下载）
     */
    IMWebImageLowPriority = 1 << 1,
    /**
     * 仅内存缓存
     */
    IMWebImageCacheMemoryOnly = 1 << 2,
    /**
     * 渐进式下载（如浏览器，下载一截展示一截）
     */
    IMWebImageProgressiveDownload = 1 << 3,
    /**
     * 重新下载，更新缓存
     */
    IMWebImageRefreshCached = 1 << 4,
    /**
     * 开始后台下载（比如app进入后台，仍然下载）
     */
    IMWebImageContinueInBackground = 1 << 5,
    /**
     * 可以控制存在NSHTTPCookieStore的cookies.
     */
    IMWebImageHandleCookies = 1 << 6,
    /**
     * 允许无效的ssl证书
     */
    IMWebImageAllowInvalidSSLCertificates = 1 << 7,
    /**
     * 高优先级，会放在队头下载
     */
    IMWebImageHighPriority = 1 << 8,
    /**
     * 延时展示占位图（图片下载失败时才展示）
     */
    IMWebImageDelayPlaceholder = 1 << 9,
    /**
     * 动图相关（猜测）
     */
    IMWebImageTransformAnimatedImage = 1 << 10,
    /**
     * 图片下载完成之后不自动给imageView设置
     */
    IMWebImageAvoidAutoSetImage = 1 << 11,
    /**
     * 根据设备屏幕类型，进行放大缩小（@1x, @2x, @3x）
     */
    IMWebImageScaleDownLargeImages = 1 << 12
};

typedef NS_ENUM(NSInteger, IMImageCacheType) {
    /**
     * 无缓存
     */
    IMImageCacheTypeNone,
    /**
     * 磁盘缓存
     */
    IMImageCacheTypeDisk,
    /**
     * 内存缓存
     */
    IMImageCacheTypeMemory
};

typedef void (^IMWebImageDownloadCompleteBlock)(UIImage *image, NSError *error, IMImageCacheType cacheType, NSURL *imageURL);
typedef void (^IMWebImageDownloaderProgressBlock)(NSInteger receivedSize, NSInteger expectedSize, NSURL *targetURL);

@interface UIImageView (IMWebImage)

- (void)tt_setImageWithURL:(NSURL *)url;
- (void)tt_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
- (void)tt_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(IMWebImageOptions)options;
- (void)tt_setImageWithURL:(NSURL *)url completed:(IMWebImageDownloadCompleteBlock)completedBlock;
- (void)tt_setImageWithURL:(NSURL *)url options:(IMWebImageOptions)options completed:(IMWebImageDownloadCompleteBlock)completedBlock;
- (void)tt_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(IMWebImageDownloadCompleteBlock)completedBlock;
- (void)tt_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(IMWebImageOptions)options completed:(IMWebImageDownloadCompleteBlock)completedBlock;
- (void)tt_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(IMWebImageOptions)options progress:(IMWebImageDownloaderProgressBlock)progressBlock completed:(IMWebImageDownloadCompleteBlock)completedBlock;

- (void)tt_cancelCurrentImageLoad;

@end
