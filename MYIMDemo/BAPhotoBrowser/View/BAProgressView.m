//
//  BAProgressView.m
//  IMXiniuCloud
//
//  Created by eims on 2018/5/17.
//  Copyright © 2018年 EIMS. All rights reserved.
//

#import "BAProgressView.h"

@implementation BAProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = IMProgressViewBackgroundColor;
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
        self.mode = IMProgressViewProgressMode;
    }
    return self;
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    [self setNeedsDisplay];
    if (progress >= 1) {
        [self removeFromSuperview];
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat xCenter = rect.size.width * 0.5;
    CGFloat yCenter = rect.size.height * 0.5;
    [self.backgroundColor setFill];
    [IMProgressViewStrokeColor setStroke];
    
    switch (self.mode) {
        case IMProgressViewModePieDiagram:
        {
            CGFloat radius = MIN(rect.size.width * 0.5, rect.size.height * 0.5) - IMProgressViewItemMargin;
            
            CGFloat w = radius * 2 + IMProgressViewItemMargin;
            CGFloat h = w;
            CGFloat x = (rect.size.width - w) * 0.5;
            CGFloat y = (rect.size.height - h) * 0.5;
            CGContextAddEllipseInRect(ctx, CGRectMake(x, y, w, h));
            CGContextSetLineWidth(ctx, IMProgressViewLoopDiagramLineWidth * 0.5);
            CGContextStrokePath(ctx);
            
            [IMProgressViewStrokeColor setFill];
            CGContextMoveToPoint(ctx, xCenter, yCenter);
            CGContextAddLineToPoint(ctx, xCenter, 0);
            CGFloat to = - M_PI * 0.5 + self.progress * M_PI * 2 + 0.001; // 初始值
            CGContextAddArc(ctx, xCenter, yCenter, radius, - M_PI * 0.5, to, 0);
            CGContextClosePath(ctx);
            CGContextFillPath(ctx);
        }
            break;
            
        default:
        {
            CGContextSetLineWidth(ctx, IMProgressViewLoopDiagramLineWidth);
            CGContextSetLineCap(ctx, kCGLineCapRound);
            [IMProgressViewStrokeColor setStroke];
            CGFloat to = - M_PI * 0.5 + self.progress * M_PI * 2 + 0.05; // 初始值0.05
            CGFloat radius = MIN(rect.size.width, rect.size.height) * 0.5 - IMProgressViewItemMargin;
            CGContextAddArc(ctx, xCenter, yCenter, radius, - M_PI * 0.5, to, 0);
            CGContextStrokePath(ctx);
        }
            break;
    }
}

@end
