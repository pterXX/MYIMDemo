//
//  UIView+IMSeparator.h
//  TLChat
//
//  Created by 李伯坤 on 2017/7/5.
//  Copyright © 2017年 李伯坤. All rights reserved.
//

//  给View添加分割线，未完成

#import <UIKit/UIKit.h>

#define     IMSEPERATOR_DEFAULT_COLOR       [UIColor colorWithString:@"#eaeaea" alpha:1.0]

typedef NS_ENUM(NSInteger, IMSeparatorPosition) {
    IMSeparatorPositionTop,
    IMSeparatorPositionBottom,
    IMSeparatorPositionLeft,
    IMSeparatorPositionRight,
    IMSeparatorPositionCenterX,
    IMSeparatorPositionCenterY,
};

@class IMSeparatorModel;
@interface IMSeparatorChainModel : NSObject

/// 偏移量（相对于方向）
- (IMSeparatorChainModel *(^)(CGFloat offset))offset;
/// 颜色
- (IMSeparatorChainModel *(^)(UIColor *color))color;
/// 起点
- (IMSeparatorChainModel *(^)(CGFloat begin))beginAt;
/// 长度
- (IMSeparatorChainModel *(^)(CGFloat length))length;
/// 终点（优先使用长度）
- (IMSeparatorChainModel *(^)(CGFloat end))endAt;
/// 线粗
- (IMSeparatorChainModel *(^)(CGFloat borderWidth))borderWidth;

@end

@interface UIView (IMSeparator)

- (IMSeparatorChainModel *(^)(IMSeparatorPosition position))addSeparator;

- (void (^)(IMSeparatorPosition position))removeSeparator;

- (void)updateSeparator;

@end
