//
//  IMExpressionGroupModel+DetailRequest.h
//  IMChat
//
//  Created by 徐世杰 on 2018/1/2.
//  Copyright © 2018年 徐世杰. All rights reserved.
//

#import "IMExpressionGroupModel.h"

@interface IMExpressionGroupModel (DetailRequest)

/**
 *  表情详情
 */
- (IMBaseRequest *)requestExpressionGroupDetailByPageIndex:(NSInteger)pageIndex success:(IMRequestSuccessBlock)success failure:(IMRequestFailureBlock)failure;

@end
