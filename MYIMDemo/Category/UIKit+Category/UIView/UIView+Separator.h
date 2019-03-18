//
//  UIView+Separator.h
//  MYIMDemo
//
//  Created by admin on 2019/3/18.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SeparatorPosition) {
    SeparatorPositionTop,
    SeparatorPositionBottom,
    SeparatorPositionLeft,
    SeparatorPositionRight,
    SeparatorPositionCenterX,
    SeparatorPositionCenterY,
};

@class SeparatorModel;
@interface SeparatorChainModel : NSObject

/// 偏移量（相对于方向）
- (SeparatorChainModel *(^)(CGFloat offset))offset;
/// 颜色
- (SeparatorChainModel *(^)(UIColor *color))color;
/// 起点
- (SeparatorChainModel *(^)(CGFloat begin))beginAt;
/// 长度
- (SeparatorChainModel *(^)(CGFloat length))length;
/// 终点（优先使用长度）
- (SeparatorChainModel *(^)(CGFloat end))endAt;
/// 线粗
- (SeparatorChainModel *(^)(CGFloat borderWidth))borderWidth;

@end

@interface UIView (Separator)

- (SeparatorChainModel *(^)(SeparatorPosition position))addSeparator;

- (void (^)(SeparatorPosition position))removeSeparator;

- (void)updateSeparator;

@end

NS_ASSUME_NONNULL_END
