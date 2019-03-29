//
//  IMRecorderIndicatorView.h
//  IMChat
//
//  Created by 徐世杰 on 16/7/12.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, IMRecorderStatus) {
    IMRecorderStatusRecording,
    IMRecorderStatusWillCancel,
    IMRecorderStatusTooShort,
};

@interface IMRecorderIndicatorView : UIView

@property (nonatomic, assign) IMRecorderStatus status;

/**
 *  音量大小，取值（0-1）
 */
@property (nonatomic, assign) CGFloat volume;

@end
