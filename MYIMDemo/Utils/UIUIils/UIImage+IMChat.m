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

+ (UIImage *)imageInputboxMenuAdd{
    return  [UIImage imageNamed:@"icon_inputBox_menu_add"];
}

+ (UIImage *)imageInputboxRecoderTooShort{
    return  [UIImage imageNamed:@"icon_inputBox_recoder_too_short"];
}

+ (UIImage *)imageInputboxRecorderPromptRecall{
    return  [UIImage imageNamed:@"icon_inputBox_recorder_prompt_recall"];
}

+ (UIImage *)imageInputboxRecorderPromptVoice
{
    return [UIImage imageNamed:@"icon_inputBox_recorder_prompt_voice"];
}

+ (UIImage *)imageInputboxRecorderPrompt1
{
    return [UIImage imageNamed:@"icon_inputBox_recorder_prompt1"];
}

+ (UIImage *)imageInputboxMoreTakevideoFocusing{
    return [UIImage imageNamed:@"icon_inputBox_more_takeVideo_focusing"];
}

+ (UIImage *)imageInputboxMoreTakevideoBack{
    return [UIImage imageNamed:@"icon_inputBox_more_takeVideo_back"];
}

+ (UIImage *)imageInputboxMoreTakevideoPhotograph{
     return [UIImage imageNamed:@"icon_inputBox_more_takeVideo_photograph"];
}

+ (UIImage *)imageInputboxMoreTakevideoCancel{
    return [UIImage imageNamed:@"icon_inputBox_more_takeVideo_cancel"];
}

+ (UIImage *)imageInputboxMoreTakevideoConfirm{
    return [UIImage imageNamed:@"icon_inputBox_more_takeVideo_confirm"];
}

+ (UIImage *)imageInputboxMoreTakevideoCamera{
    return [UIImage imageNamed:@"icon_inputBox_more_takeVideo_camera"];
}


+ (UIImage *)imageMessageSendFailure{
    return  [UIImage imageNamed:@"icon_message_send_failure"];
}



@end
