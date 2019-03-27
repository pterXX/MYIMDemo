//
//  IMExpressionGroupModel+MoreRequest.h
//  IMChat
//
//  Created by 李伯坤 on 2018/1/2.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import "IMExpressionGroupModel.h"

@interface IMExpressionGroupModel (MoreRequest)

/**
 *  更多表情 —— 更多列表
 */
+ (IMBaseRequest *)requestExpressionMoreListByPageIndex:(NSInteger)page success:(IMRequestSuccessBlock)success failure:(IMRequestFailureBlock)failure;

@end
