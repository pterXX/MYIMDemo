//
//  IMImageDownloader.h
//  IMChat
//
//  Created by 徐世杰 on 2017/7/13.
//  Copyright © 2017年 徐世杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMImageDownloader : NSObject

/// 是否按队列顺序执行回调（默认NO）
@property (nonatomic, assign) BOOL useQueue;
/// 是否正在下载
@property (nonatomic, assign) BOOL isDownloading;
/// 当前任务数量
@property (nonatomic, assign) NSInteger curTaskCount;

- (void)addDownloadTaskWithUrl:(NSString *)urlString completeAction:(void (^)(BOOL success, UIImage *image))completeAction;
- (void)startDownload;
- (void)cancelDownload;

@end
