//
//  IMVideoPlayView.h
//  IMXiniuCloud
//
//  Created by eims on 2018/5/17.
//  Copyright © 2018年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IMVideoPlayView;
@protocol IMVideoPlayViewDelegate <NSObject>

- (void)videoPlayView:(IMVideoPlayView *)videoPlayView clickBackButton:(UIButton *)back;

@end


@interface IMVideoPlayView : UIView

// 视频URL
@property (nonatomic, strong) NSURL *videoUrl;

@property (nonatomic, assign) id<IMVideoPlayViewDelegate> delegate;

- (void)play;
- (void)stop;

@end
