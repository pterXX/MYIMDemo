//
//  UIView+Frame.h
//  YunShiFinance
//
//  Created by Apple on 2018/7/9.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat maxX;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat maxY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;


@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize  size;

- (UIImage *)makeImageWithView:(UIView *)view withSize:(CGSize)size;
- (void)addShadow:(CGFloat)width;
-(UIImage *)addHeadImage:(UIImage *)headImage footImage:(UIImage *)footImage toMasterImage:(UIImage *)masterImage;


- (void)adaptSizeSubViewsYouUIScreenWidth:(CGFloat)width;
- (NSArray *)allProperties:(UIView *)view;


/**
 隐藏所有视图
 */
- (void)hideAllSubView;

/**
 显示所有视图
 */
- (void)showAllSubView;


+ (CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor startPoint:(CGPoint )startPoint endPoint:(CGPoint )endPoint;





/**
 通过 CAShapeLayer 方式绘制虚线
 
 @param lineLength 虚线的宽度
 @param lineSpacing  虚线的间距
 @param lineColor  虚线的颜色
 @param width 虚线的宽度
 @param startPoint 起点
 @param endPoint 终点
 */
- (void)drawLineOfDashByCAShapeLayerLineLength:(int)lineLength
                                   lineSpacing:(int)lineSpacing
                                     lineColor:(UIColor *)lineColor
                                         width:(CGFloat)width
                                    startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint ;
@end

