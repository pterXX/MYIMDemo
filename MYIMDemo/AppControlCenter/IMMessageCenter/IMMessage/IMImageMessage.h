//
//  IMImageMessage.h
//  IMChat
//
//  Created by libokun on 16/3/28.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "IMMessage.h"

@interface IMImageMessage : IMMessage

@property (nonatomic, strong) NSString *imagePath;                  // 本地图片Path
@property (nonatomic, strong) NSString *imageURL;                   // 网络图片URL
@property (nonatomic, assign) CGSize imageSize;

@end
