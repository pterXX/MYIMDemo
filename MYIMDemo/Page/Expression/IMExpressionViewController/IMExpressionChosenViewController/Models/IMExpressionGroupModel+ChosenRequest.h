//
//  IMExpressionGroupModel+ChosenRequest.h
//  IMChat
//
//  Created by 李伯坤 on 2018/1/2.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import "IMExpressionGroupModel.h"
#import "IMPictureCarouselProtocol.h"

@interface IMExpressionGroupModel (ChosenRequest)

/**
 *  表情精选 - Banner
 */
+ (IMBaseRequest *)requestExpressionChosenBannerSuccess:(IMRequestSuccessBlock)success failure:(IMRequestFailureBlock)failure;

/**
 *  表情精选 - 推荐模块
 */
+ (void)requestExpressionRecommentListSuccess:(IMRequestSuccessBlock)success failure:(IMRequestFailureBlock)failure;

/**
 *  表情精选 - 更多模块
 */
+ (IMBaseRequest *)requestExpressionChosenListByPageIndex:(NSInteger)page success:(IMRequestSuccessBlock)success failure:(IMRequestFailureBlock)failure;


@end
