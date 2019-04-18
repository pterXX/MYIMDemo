//
//  IMPhotoBrowserConfig.h
//  IMXiniuCloud
//
//  Created by eims on 2018/5/17.
//  Copyright © 2018年 EIMS. All rights reserved.
//

#define IMPhotoBrowserDebug 1
// 是否开启断言调试模式
#define IsOpenAssertDebug 1
#define IMPhotoBrowserVersion @"1.2.0"

/**
 *  进度视图类型类型
 */
typedef NS_ENUM(NSUInteger, IMProgressViewMode) {
    IMProgressViewModeLoopDiagram = 0,   // 圆环形
    IMProgressViewModePieDiagram         // 圆饼型
};

/**
 *  图片浏览器的样式
 */
typedef NS_ENUM(NSUInteger, IMPhotoBrowserStyle) {
    // 长按图片弹出功能组件,底部一个PageControl
    IMPhotoBrowserStylePageControl = 0,
    // 长按图片弹出功能组件,顶部一个索引UILabel
    IMPhotoBrowserStyleIndeKabel,
    // 没有长按图片弹出的功能组件,顶部一个索引UILabel,底部一个保存图片按钮
    IMPhotoBrowserStyleSimple
};

/**
 *  pageControl的位置
 */
typedef NS_ENUM(NSUInteger, IMPhotoBrowserPageControlAliment) {
    IMPhotoBrowserPageControlAlimentRight = 0,   // 右边
    IMPhotoBrowserPageControlAlimentCenter,      // 中间
    IMPhotoBrowserPageControlAlimentLeft         // 左边
};

/**
 *  pageControl的样式
 */
typedef NS_ENUM(NSUInteger, IMPhotoBrowserPageControlStyle) {
    IMPhotoBrowserPageControlStyleClassic = 0,   // 系统自带经典样式
    IMPhotoBrowserPageControlStyleAnimated,      // 动画效果pagecontrol
    IMPhotoBrowserPageControlStyleNone           // 不显示pagecontrol
};

#define IMPhotoBrowserLoadingImageText       @"图片加载中,请稍后 ";
// 图片保存成功提示文字
#define IMPhotoBrowserSaveImageSuccessText   @"保存成功 ";
// 图片保存失败提示文字
#define IMPhotoBrowserSaveImageFailText      @"保存失败 ";
// 网络图片加载失败的提示文字
#define IMPhotoBrowserLoadNetworkImageFail   @"图片加载失败"

// browser 图片间的margin
#define IMPhotoBrowserImageViewMargin 10
// browser 中显示图片动画时长
#define IMPhotoBrowserShowImageAnimationDuration 0.4f
// browser 中显示图片动画时长
#define IMPhotoBrowserHideImageAnimationDuration 0.2f
// browser 背景颜色
#define IMPhotoBrowserBackgrounColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.95]

// 图片下载进度指示进度显示样式（IMProgressViewModeLoopDiagram 环形，IMProgressViewModePieDiagram 饼型）
#define IMProgressViewProgressMode IMProgressViewModeLoopDiagram
// 图片下载进度指示器背景色
#define IMProgressViewBackgroundColor [UIColor clearColor]
// 图片下载进度指示器圆环/圆饼颜色
#define IMProgressViewStrokeColor [UIColor whiteColor]
// 图片下载进度指示器内部控件间的间距
#define IMProgressViewItemMargin 10
// 圆环形图片下载进度指示器 环线宽度
#define IMProgressViewLoopDiagramLineWidth 8

#define IMPBLog(...) IMFormatLog(__VA_ARGS__)

#if IMPhotoBrowserDebug
#define IMFormatLog(...)\
{\
NSString *string = [NSString stringWithFormat:__VA_ARGS__];\
NSLog(@"\n===========================\n===========================\n=== IMPhotoBrowser' Log ===\n提示信息:%@\n所在方法:%s\n所在行数:%d\n===========================\n===========================",string,__func__,__LINE__);\
}

#define IMLogFunc NSLog(@"%s", __func__)

#else
#define IMFormatLog(...)
#define IMLogFunc
#endif

