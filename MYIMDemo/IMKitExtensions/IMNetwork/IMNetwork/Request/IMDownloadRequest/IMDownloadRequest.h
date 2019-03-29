//
//  IMDownloadRequest.h
//  IMChat
//
//  Created by 徐世杰 on 2017/7/14.
//  Copyright © 2017年 徐世杰. All rights reserved.
//

#import "IMBaseRequest.h"

@interface IMDownloadRequest : IMBaseRequest

/// 下载缓存路径
@property (nonatomic, strong) NSString *downloadPath;

/// 下载进度
@property (nonatomic, copy) IMRequestProgressBlock downloadProgressAction;

@end
