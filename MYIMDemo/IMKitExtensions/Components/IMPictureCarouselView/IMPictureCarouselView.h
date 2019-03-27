//
//  IMPictureCarouselView.h
//  IMChat
//
//  Created by 李伯坤 on 16/4/20.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMPictureCarouselProtocol.h"

#define         DEFAULT_TIMEINTERVAL        3.0f

@class IMPictureCarouselView;
@protocol IMPictureCarouselDelegate <NSObject>

- (void)pictureCarouselView:(IMPictureCarouselView *)pictureCarouselView
              didSelectItem:(id<IMPictureCarouselProtocol>)model;

@end

@interface IMPictureCarouselView : UIView

@property (nonatomic, assign) id<IMPictureCarouselDelegate> delegate;

@property (nonatomic, copy) void (^didSelectItem)(IMPictureCarouselView *pictureCarouselView, id<IMPictureCarouselProtocol> model);

@property (nonatomic, assign) NSTimeInterval timeInterval;

- (void)setData:(NSArray *)data;

@end
