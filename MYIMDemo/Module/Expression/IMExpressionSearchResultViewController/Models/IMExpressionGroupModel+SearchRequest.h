//
//  IMExpressionGroupModel+SearchRequest.h
//  IMChat
//
//  Created by 徐世杰 on 2018/1/2.
//  Copyright © 2018年 徐世杰. All rights reserved.
//

#import "IMExpressionGroupModel.h"

@interface IMExpressionGroupModel (SearchRequest)

/**
 *  表情搜索
 */
+ (IMBaseRequest *)requestExpressionSearchByKeyword:(NSString *)keyword success:(IMRequestSuccessBlock)success failure:(IMRequestFailureBlock)failure;

@end
