//
//  IMExpressionGroupModel+MoreRequest.m
//  IMChat
//
//  Created by 李伯坤 on 2018/1/2.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import "IMExpressionGroupModel+MoreRequest.h"

#import "IMNetworking.h"

// 表情服务器
#define     IEXPRESSION_HOST_URL        @"http://123.57.155.230/ibiaoqing/admin/"
#define     IEXPRESSION_MORE_URL        [IEXPRESSION_HOST_URL stringByAppendingString:@"expre/listBy.do?pageNumber=%ld&status=Y&status1=B&count=yes"]

@implementation IMExpressionGroupModel (MoreRequest)

+ (IMBaseRequest *)requestExpressionMoreListByPageIndex:(NSInteger)page success:(IMRequestSuccessBlock)success failure:(IMRequestFailureBlock)failure
{
    NSString *urlString = [NSString stringWithFormat:IEXPRESSION_MORE_URL, (long)page];
    [IMNetworking postUrl:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *respArray = [responseObject mj_JSONObject];
        NSString *status = respArray[0];
        if ([status isEqualToString:@"OK"]) {
            NSArray *infoArray = respArray[2];
            NSMutableArray *data = [IMExpressionGroupModel mj_objectArrayWithKeyValuesArray:infoArray];
            if (success) {
                success(data);
            }
        }
        else {
            if (failure) {
                failure(status);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(IMNetworkErrorTip);
        }
    }];
//    NSString *urlString = [NSString stringWithFormat:IEXPRESSION_MORE_URL, (long)page];
//    IMBaseRequest *request = [IMBaseRequest requestWithMethod:IMRequestMethodPOST url:urlString parameters:nil];
//    [request startRequestWithSuccessAction:^(IMResponse *response) {
//        NSArray *respArray = [response.responseData mj_JSONObject];
//        NSString *status = respArray[0];
//        if ([status isEqualToString:@"OK"]) {
//            NSArray *infoArray = respArray[2];
//            NSMutableArray *data = [IMExpressionGroupModel mj_objectArrayWithKeyValuesArray:infoArray];
//            if (success) {
//                success(data);
//            }
//        }
//        else {
//            if (failure) {
//                failure(status);
//            }
//        }
//    } failureAction:^(IMResponse *response) {
//        if (failure) {
//            failure(IMNetworkErrorTip);
//        }
//    }];
//    return request;
    return nil;
}

@end
