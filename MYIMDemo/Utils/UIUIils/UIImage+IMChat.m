//
//  UIImage+IMChat.m
//  MYIMDemo
//
//  Created by 徐世杰 on 2019/3/1.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "UIImage+IMChat.h"

@implementation UIImage (IMChat)
+ (UIImage *)imageDefaultHeadPortrait{
    return  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"WechatIMG5" ofType:@"png"]];
}

+ (UIImage *)imageInputBoxVideoBttomPlay{
    return  [UIImage imageNamed:@"icon_inputBox_video_bttom_play"];
}

+ (UIImage *)imageInputBoxVideoPlayCancel{
    return  [UIImage imageNamed:@"icon_inputBox_videoPlay_cancel"];
}

+ (UIImage *)imageInputBoxVideoPlay{
    return  [UIImage imageNamed:@"icon_inputBox_video_play"];
}

+ (UIImage *)imageInputBoxVideoPause{
    return  [UIImage imageNamed:@"icon_inputBox_video_ pause"];
}

+ (UIImage *)imageInputBoxThumb{
    return  [UIImage imageNamed:@"icon_inputBox_thumb"];
}

@end
