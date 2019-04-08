//
//  IMExpressionDownloadButton.h
//  IMChat
//
//  Created by 徐世杰 on 2018/1/2.
//  Copyright © 2018年 徐世杰. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, IMExpressionDownloadButtonStatus) {
    IMExpressionDownloadButtonStatusNet,
    IMExpressionDownloadButtonStatusDownloading,
    IMExpressionDownloadButtonStatusDownloaded,
};

@interface IMExpressionDownloadButton : UIView

@property (nonatomic, assign) IMExpressionDownloadButtonStatus status;

@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, copy) void (^downloadButtonClick)();

@end
