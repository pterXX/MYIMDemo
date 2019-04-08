//
//  IMExpressionGroupModel+MoreRequest.h
//  IMChat
//
//  Created by 徐世杰 on 2018/1/2.
//  Copyright © 2018年 徐世杰. All rights reserved.
//

#import "IMExpressionGroupModel.h"

@interface IMExpressionGroupModel (MoreRequest)

/**
 *  更多表情 —— 更多列表
 */
+ (IMBaseRequest *)requestExpressionMoreListByPageIndex:(NSInteger)page success:(IMRequestSuccessBlock)success failure:(IMRequestFailureBlock)failure;

@end
