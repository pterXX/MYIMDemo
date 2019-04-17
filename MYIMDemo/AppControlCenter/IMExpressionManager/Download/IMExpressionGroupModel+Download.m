//
//  IMExpressionGroupModel+Download.m
//  IMChat
//
//  Created by 徐世杰 on 2018/1/2.
//  Copyright © 2018年 徐世杰. All rights reserved.
//

#import "IMExpressionGroupModel+Download.h"
#import "IMExpressionGroupModel+DetailRequest.h"
#import "IMExpressionHelper.h"
#import "NSFileManager+IMChat.h"

@implementation IMExpressionGroupModel (Download)

- (void)startDownload
{
    self.status = IMExpressionGroupStatusDownloading;
    if (self.data.count == 0) {
        self.data = @[].mutableCopy;
        [self requestDetailInfoWithPageIndex:1];
    }
    else {
        [self p_startDownload];
    }
}

- (void)requestDetailInfoWithPageIndex:(NSInteger)pageIndex
{
    [self requestExpressionGroupDetailByPageIndex:pageIndex success:^(NSArray *successData) {
        if (successData.count > 0) {
            [self.data addObjectsFromArray:successData];

            [self p_startDownload];
        }
        else {
            self.status = IMExpressionGroupStatusNet;
            if (self.downloadCompleteAction) {
                self.downloadCompleteAction(self, NO, @"表情包数据错误");
            }
        }
    } failure:^(id failureData) {
        self.status = IMExpressionGroupStatusNet;
        if (self.downloadCompleteAction) {
            self.downloadCompleteAction(self, NO, @"获取表情包信息失败");
        }
    }];
}

- (void)p_startDownload
{
    [[IMExpressionHelper sharedHelper] downloadExpressionsWithGroupInfo:self progress:^(CGFloat progress) {
        self.downloadProgress = progress;
        if (self.downloadProgressAction) {
            self.downloadProgressAction(self, progress);
        }
    } success:^(IMExpressionGroupModel *group) {
        self.status = IMExpressionGroupStatusLocal;
        [[IMExpressionHelper sharedHelper] addExpressionGroup:group];
        if (self.downloadCompleteAction) {
            self.downloadCompleteAction(group, YES, nil);
        }
    } failure:^(IMExpressionGroupModel *group, NSString *error) {
        self.status = IMExpressionGroupStatusNet;
        if (self.downloadCompleteAction) {
            self.downloadCompleteAction(group, NO, error);
        }
    }];
}


@end
