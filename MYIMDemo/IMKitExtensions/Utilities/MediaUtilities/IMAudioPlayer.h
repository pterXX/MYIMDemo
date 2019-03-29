//
//  IMAudioPlayer.h
//  IMChat
//
//  Created by 徐世杰 on 16/7/12.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMAudioPlayer : NSObject

@property (nonatomic, assign, readonly) BOOL isPlaying;

+ (IMAudioPlayer *)sharedAudioPlayer;

- (void)playAudioAtPath:(NSString *)path complete:(void (^)(BOOL finished))complete;

- (void)stopPlayingAudio;

@end
