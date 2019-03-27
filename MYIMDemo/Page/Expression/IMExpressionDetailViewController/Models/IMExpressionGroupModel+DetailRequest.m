//
//  IMExpressionGroupModel+DetailRequest.m
//  IMChat
//
//  Created by 李伯坤 on 2018/1/2.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import "IMExpressionGroupModel+DetailRequest.h"
#import "IMNetworking.h"

#define     IEXPRESSION_DETAIL_URL      [IEXPRESSION_HOST_URL stringByAppendingString:@"expre/getByeId.do?pageNumber=%ld&eId=%@"]

@implementation IMExpressionGroupModel (DetailRequest)

- (IMBaseRequest *)requestExpressionGroupDetailByPageIndex:(NSInteger)pageIndex success:(IMRequestSuccessBlock)success failure:(IMRequestFailureBlock)failure
{
    NSString *urlString = [NSString stringWithFormat:IEXPRESSION_DETAIL_URL, (long)pageIndex, self.gId];
    [IMNetworking postUrl:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *respArray = [responseObject mj_JSONObject];
        NSString *status = respArray[0];
        if ([status isEqualToString:@"OK"]) {
            NSArray *infoArray = respArray[2];
            NSMutableArray *data = [IMExpressionModel mj_objectArrayWithKeyValuesArray:infoArray];
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
