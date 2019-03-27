//
//  IMVoiceMessage.h
//  IMChat
//
//  Created by 李伯坤 on 16/7/11.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "IMMessage.h"

typedef NS_ENUM(NSInteger, IMVoiceMessageStatus) {
    IMVoiceMessageStatusNormal,
    IMVoiceMessageStatusRecording,
    IMVoiceMessageStatusPlaying,
};

@interface IMVoiceMessage : IMMessage

@property (nonatomic, strong) NSString *recFileName;

@property (nonatomic, strong, readonly) NSString *path;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) CGFloat time;

@property (nonatomic, assign) IMVoiceMessageStatus msgStatus;

@end
