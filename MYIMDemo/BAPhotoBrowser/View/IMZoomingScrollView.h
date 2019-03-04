//
//  IMZoomingScrollView.h
//  XLPhotoBrowserDemo
//
//  Created by Liushannoon on 16/7/15.
//  Copyright © 2016年 LiuShannoon. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IMPhoto.h"

@class IMVideoPlayView;
@class IMZoomingScrollView;

@protocol IMZoomingScrollViewDelegate <NSObject>

/**
 *  单击图像时调用
 *
 *  @param zoomingScrollView 图片缩放视图
 *  @param singleTap             用户单击手势
 */
- (void)zoomingScrollView:(IMZoomingScrollView *)zoomingScrollView singleTapDetected:(UITapGestureRecognizer *)singleTap;

@optional
/**
 *  图片加载进度
 *
 *  @param zoomingScrollView 图片缩放视图
 *  @param progress 加载进度 , 0 - 1.0
 */
- (void)zoomingScrollView:(IMZoomingScrollView *)zoomingScrollView imageLoadProgress:(CGFloat)progress;

@end


@interface IMZoomingScrollView : UIView

@property (nonatomic, assign) BOOL isAutoPlay;

/**
 *  zoomingScrollViewdelegate
 */
@property (nonatomic , weak) id <IMZoomingScrollViewDelegate> zoomingScrollViewdelegate;
// 视频播放器
@property (nonatomic, strong) IMVideoPlayView *videoPlayer;
/**
 *  图片加载进度
 */
@property (nonatomic, assign) CGFloat progress;
/**
 *  展示的图片
 */
//@property (nonatomic , strong , readonly) UIImage  *currentImage;

/**
 需要展示的数据。可能是图片，也可能是视频
 */
@property (nonatomic, strong) IMPhoto *photo;
/**
 *  展示图片的UIImageView视图  ,  回缩的动画用
 */
@property (nonatomic , weak , readonly) UIImageView *imageView;
@property (nonatomic , strong , readonly) UIScrollView *scrollview;

/**
 *  显示图片
 *
 *  @param photo 占位的缩略图 / 或者是高清大图都可以
 */
- (void)setShowHighQualityImageWithPhoto:(IMPhoto *)photo;
/**
 *  显示图片
 *
 *  @param photo 图片
 */
- (void)setShowImage:(IMPhoto *)photo;
/**
 *  调整尺寸
 */
- (void)setMaxAndMinZoomScales;
/**
 *  重用，清理资源
 */
- (void)prepareForReuse;

@end
