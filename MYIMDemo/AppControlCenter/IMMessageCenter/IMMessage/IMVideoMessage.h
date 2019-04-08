//
//  IMVideoMessage.h
//  IMChat
//
//  Created by 徐世杰 on 16/10/1.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "IMMessage.h"

@interface IMVideoMessage : IMMessage

@property (nonatomic, strong, readonly) NSString *videoPath;
@property (nonatomic, strong) NSString *videoURL;

@property (nonatomic, strong, readonly) NSString *imagePath;                  // 本地图片Path
@property (nonatomic, strong) NSString *imageURL;                   // 网络图片URL
@property (nonatomic, assign) CGSize imageSize;

@end
