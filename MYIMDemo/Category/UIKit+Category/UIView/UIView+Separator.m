//
//  UIView+Separator.m
//  MYIMDemo
//
//  Created by admin on 2019/3/18.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "UIView+Separator.h"
#import <objc/runtime.h>

#define     TLSEPERATOR_DEFAULT_COLOR       [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0]
#define     SEPARATOR_BORDER_WIDTH_1PX            ([[UIScreen mainScreen] scale] > 0.0 ? 1.0 / [[UIScreen mainScreen] scale] : 1.0)
#pragma mark - ## SeparatorModel
@interface SeparatorModel : NSObject

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) SeparatorPosition position;

@property (nonatomic, assign) CGFloat borderWidth;

@property (nonatomic, assign) CGFloat offset;

@property (nonatomic, assign) CGFloat begin;
@property (nonatomic, assign) CGFloat end;
@property (nonatomic, assign) CGFloat length;

@property (nonatomic, strong, readonly) CAShapeLayer *layer;

@end

@implementation SeparatorModel
@synthesize layer = _layer;

- (id)init
{
    if (self = [super init]) {
        [self setPosition:SeparatorPositionBottom];
        [self setColor:TLSEPERATOR_DEFAULT_COLOR];
        [self setBegin:0];
        [self setEnd:0];
        [self setLength:0];
        [self setBorderWidth:SEPARATOR_BORDER_WIDTH_1PX];
    }
    return self;
}

- (CAShapeLayer *)layer
{
    if (!_layer) {
        _layer = [CAShapeLayer layer];
    }
    return _layer;
}

@end

#pragma mark - ## SeparatorChainModel

@interface SeparatorChainModel ()

@property (nonatomic, weak, readonly) UIView *view;
@property (nonatomic, strong, readonly) SeparatorModel *SeparatorModel;

@end

@implementation SeparatorChainModel
@synthesize SeparatorModel = _SeparatorModel;

- (id)initWithView:(UIView *)view andPosition:(SeparatorPosition)position
{
    if (self = [super init]) {
        _view = view;
        [self.SeparatorModel setPosition:position];
    }
    return self;
}

/// 偏移量
- (SeparatorChainModel *(^)(CGFloat offset))offset
{
    @weakify(self);
    return ^(CGFloat offset) {
        @strongify(self);
        [self.SeparatorModel setOffset:offset];
        [self.view updateSeparator];
        return self;
    };
}

/// 位置
- (SeparatorChainModel *(^)(UIColor *color))color
{
    @weakify(self);
    return ^(UIColor *color) {
        @strongify(self);
        [self.SeparatorModel setColor:color];
        [self.view updateSeparator];
        return self;
    };
}
/// 起点
- (SeparatorChainModel *(^)(CGFloat begin))beginAt
{
    @weakify(self);
    return ^(CGFloat begin) {
        @strongify(self);
        [self.SeparatorModel setBegin:begin];
        [self.view updateSeparator];
        return self;
    };
}
/// 长度
- (SeparatorChainModel *(^)(CGFloat length))length
{
    @weakify(self);
    return ^(CGFloat length) {
        @strongify(self);
        [self.SeparatorModel setLength:length];
        [self.view updateSeparator];
        return self;
    };
}
/// 终点
- (SeparatorChainModel *(^)(CGFloat end))endAt
{
    @weakify(self);
    return ^(CGFloat end) {
        @strongify(self);
        [self.SeparatorModel setEnd:end];
        [self.view updateSeparator];
        return self;
    };
}
/// 线粗
- (SeparatorChainModel *(^)(CGFloat borderWidth))borderWidth;
{
    @weakify(self);
    return ^(CGFloat borderWidth) {
        @strongify(self);
        [self.SeparatorModel setBorderWidth:borderWidth];
        [self.view updateSeparator];
        return self;
    };
}

#pragma mark - # Getters
- (SeparatorModel *)SeparatorModel
{
    if (!_SeparatorModel) {
        _SeparatorModel = [[SeparatorModel alloc] init];
    }
    return _SeparatorModel;
}

@end

#pragma mark - ## UIView (Separator)
@implementation UIView (Separator)

- (SeparatorChainModel *(^)(SeparatorPosition position))addSeparator;
{
    @weakify(self);
    return ^(SeparatorPosition position) {
        @strongify(self);
        SeparatorChainModel *chainModel = [[SeparatorChainModel alloc] initWithView:self andPosition:position];
        self.removeSeparator(position);
        [self.SeparatorArray addObject:chainModel.SeparatorModel];
        [self updateSeparator];
        return chainModel;
    };
}

- (void (^)(SeparatorPosition position))removeSeparator
{
    @weakify(self);
    return ^(SeparatorPosition position) {
        @strongify(self);
        SeparatorModel *model = [self SeparatorModelForPosition:position];
        if (model) {
            [model.layer removeFromSuperlayer];
            [self.SeparatorArray removeObject:model];
        }
    };
}

- (void)updateSeparator
{
    for (SeparatorModel *model in self.SeparatorArray) {
        [self updateSeparatorWithModel:model];
    }
}

#pragma mark - # Private Methods
- (SeparatorModel *)SeparatorModelForPosition:(SeparatorPosition)position
{
    for (SeparatorModel *model in self.SeparatorArray) {
        if (model.position == position) {
            return model;
        }
    }
    return nil;
}

- (void)updateSeparatorWithModel:(SeparatorModel *)separatorModel
{
    CGFloat startX = 0, startY = 0, endX = 0, endY = 0, offset = separatorModel.offset;
    CGFloat borderWidth = separatorModel.borderWidth;
    UIColor *color = separatorModel.color;
    if (separatorModel.position == SeparatorPositionTop) {
        startY = endY = borderWidth / 2.0 + offset;
        startX = separatorModel.begin;
        if (separatorModel.length > 0) {
            endX = startX + separatorModel.length;
        }
        else {
            endX = self.frame.size.width + separatorModel.end;
        }
    }
    else if (separatorModel.position == SeparatorPositionBottom) {
        startY = endY = self.frame.size.height - borderWidth / 2.0 + offset;
        startX = separatorModel.begin;
        if (separatorModel.length > 0) {
            endX = startX + separatorModel.length;
        }
        else {
            endX = self.frame.size.width + separatorModel.end;
        }
    }
    else if (separatorModel.position == SeparatorPositionLeft) {
        startX = endX = borderWidth / 2.0 + offset;
        startY = separatorModel.begin;
        if (separatorModel.length > 0) {
            endY = startY + separatorModel.length;
        }
        else {
            endY = self.frame.size.height + separatorModel.end;
        }
    }
    else if (separatorModel.position == SeparatorPositionRight) {
        startX = endX = self.frame.size.width - borderWidth / 2.0 + offset;
        startY = separatorModel.begin;
        if (separatorModel.length > 0) {
            endY = startY + separatorModel.length;
        }
        else {
            endY = self.frame.size.height + separatorModel.end;
        }
    }
    
    CAShapeLayer *layer = separatorModel.layer;
    [layer setStrokeColor:[color CGColor]];
    [layer setFillColor:[color CGColor]];
    [layer setLineWidth:borderWidth];
    
    CGMutablePathRef path =  CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, startX, startY);
    CGPathAddLineToPoint(path, NULL, endX, endY);
    [layer setPath:path];
    CGPathRelease(path);
    
    [self.layer addSublayer:layer];
}

#pragma mark - # Getters
static NSString *__zz_sepataror_key = @"";
- (NSMutableArray *)SeparatorArray
{
    NSMutableArray *separatorArray = objc_getAssociatedObject(self, &__zz_sepataror_key);
    if (!separatorArray) {
        separatorArray = [[NSMutableArray alloc] init];
        objc_setAssociatedObject(self, &__zz_sepataror_key, separatorArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return separatorArray;
}

@end
