//
//  IMExpressionGroupModel+SearchRequest.m
//  IMChat
//
//  Created by 徐世杰 on 2018/1/2.
//  Copyright © 2018年 徐世杰. All rights reserved.
//

#import "IMExpressionGroupModel+SearchRequest.h"
#import "IMNetworking.h"

#define     IEXPRESSION_SEARCH_URL      [IEXPRESSION_HOST_URL stringByAppendingString:@"expre/listBy.do?pageNumber=1&status=Y&eName=%@&seach=yes"]

@implementation IMExpressionGroupModel (SearchRequest)

+ (IMBaseRequest *)requestExpressionSearchByKeyword:(NSString *)keyword success:(IMRequestSuccessBlock)success failure:(IMRequestFailureBlock)failure
{
    NSString *urlString = [NSString stringWithFormat:IEXPRESSION_SEARCH_URL, [[keyword urlEncode] urlEncode]];
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
    
    return nil;
}

@end
