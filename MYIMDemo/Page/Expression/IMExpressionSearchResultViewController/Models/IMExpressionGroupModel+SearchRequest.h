//
//  IMExpressionGroupModel+SearchRequest.h
//  IMChat
//
//  Created by 李伯坤 on 2018/1/2.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import "IMExpressionGroupModel.h"

@interface IMExpressionGroupModel (SearchRequest)

/**
 *  表情搜索
 */
+ (IMBaseRequest *)requestExpressionSearchByKeyword:(NSString *)keyword success:(IMRequestSuccessBlock)success failure:(IMRequestFailureBlock)failure;

@end
