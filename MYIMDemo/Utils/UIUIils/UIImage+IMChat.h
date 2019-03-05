//
//  UIImage+IMChat.h
//  MYIMDemo
//
//  Created by 徐世杰 on 2019/3/1.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (IMChat)
#pragma mark - # 默认头像
+ (UIImage *) imageDefaultHeadPortrait;

#pragma mark - # InputBox
+ (UIImage *)imageInputBoxVideoPlayCancel;
+ (UIImage *)imageInputBoxVideoBttomPlay;
+ (UIImage *)imageInputBoxVideoPlay;
+ (UIImage *)imageInputBoxVideoPause;
+ (UIImage *)imageInputBoxThumb;
+ (UIImage *)imageInputboxMenuAdd;
+ (UIImage *)imageInputboxRecoderTooShort;
+ (UIImage *)imageInputboxRecorderPromptVoice;
+ (UIImage *)imageInputboxRecorderPrompt1;
+ (UIImage *)imageInputboxRecorderPromptRecall;
+ (UIImage *)imageInputboxMoreTakevideoFocusing;
+ (UIImage *)imageInputboxMoreTakevideoBack;
+ (UIImage *)imageInputboxMoreTakevideoPhotograph;
+ (UIImage *)imageInputboxMoreTakevideoCancel;
+ (UIImage *)imageInputboxMoreTakevideoConfirm;
+ (UIImage *)imageInputboxMoreTakevideoCamera;

#pragma mark - # Status
+ (UIImage *)imageMessageSendFailure;
@end

NS_ASSUME_NONNULL_END
