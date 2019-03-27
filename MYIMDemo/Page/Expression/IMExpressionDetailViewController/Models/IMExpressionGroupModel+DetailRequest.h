//
//  IMExpressionGroupModel+DetailRequest.h
//  IMChat
//
//  Created by 李伯坤 on 2018/1/2.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import "IMExpressionGroupModel.h"

@interface IMExpressionGroupModel (DetailRequest)

/**
 *  表情详情
 */
- (IMBaseRequest *)requestExpressionGroupDetailByPageIndex:(NSInteger)pageIndex success:(IMRequestSuccessBlock)success failure:(IMRequestFailureBlock)failure;

@end
