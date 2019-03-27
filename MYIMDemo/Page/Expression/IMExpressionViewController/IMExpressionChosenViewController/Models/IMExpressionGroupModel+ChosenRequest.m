//
//  IMExpressionGroupModel+ChosenRequest.m
//  IMChat
//
//  Created by 李伯坤 on 2018/1/2.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import "IMExpressionGroupModel+ChosenRequest.h"
#import "IMNetworking.h"

#define     IEXPRESSION_BANNER_URL      [IEXPRESSION_HOST_URL stringByAppendingString: @"/advertisement/getAll.do?status=on&versionNumber=2.5.0"]
#define     IEXPRESSION_NEW_URL         [IEXPRESSION_HOST_URL stringByAppendingString:@"expre/listBy.do?pageNumber=%ld&status=Y&status1=B"]

@implementation IMExpressionGroupModel (ChosenRequest)

+ (IMBaseRequest *)requestExpressionChosenBannerSuccess:(IMRequestSuccessBlock)success failure:(IMRequestFailureBlock)failure
{
    NSString *urlString = IEXPRESSION_BANNER_URL;
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
    
//    IMBaseRequest *request = [IMBaseRequest requestWithMethod:IMRequestMethodPOST url:IEXPRESSION_BANNER_URL parameters:nil];
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

+ (IMBaseRequest *)requestExpressionChosenListByPageIndex:(NSInteger)page success:(IMRequestSuccessBlock)success failure:(IMRequestFailureBlock)failure
{
    NSString *urlString = [NSString stringWithFormat:IEXPRESSION_NEW_URL, (long)page];
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
//    NSString *urlString = [NSString stringWithFormat:IEXPRESSION_NEW_URL, (long)page];
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
    
    return nil;
}

+ (void)requestExpressionRecommentListSuccess:(IMRequestSuccessBlock)success failure:(IMRequestFailureBlock)failure
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *jsonArray = @[@{@"eId" : @"241",
                                 @"eName" : @"婉转的骂人",
                                 @"memo1" : @"杀伤力较大，慎用慎用。。。",
                                 @"coverUrl" : @"http://cdn.ibiaoqing.com:80/ibiaoqing/admin/expre/downloadsuo.do?pId=10790",
                                 @"picCount" : @(9).stringValue},
                               @{@"eId" : @"223",
                                 @"eName" : @"王锡玄",
                                 @"memo1" : @"韩国萌娃，冷笑宝宝王锡玄表情包",
                                 @"coverUrl" : @"http://cdn.ibiaoqing.com:80/ibiaoqing/admin/expre/downloadsuo.do?pId=10482",
                                 @"picCount" : @(12).stringValue},
                               @{@"eId" : @"117",
                                 @"eName" : @"克里斯蒂娜",
                                 @"memo1" : @"Cristina Fernandez Lee 混血小美女 克里斯提娜 gif 可爱 萌娃",
                                 @"coverUrl" : @"http://cdn.ibiaoqing.com:80/ibiaoqing/admin/expre/downloadsuo.do?pId=6637",
                                 @"picCount" : @(21).stringValue}];
        NSArray *data = [IMExpressionGroupModel mj_objectArrayWithKeyValuesArray:jsonArray];
        if (success) {
            success(data);
        }
    });
}

@end
