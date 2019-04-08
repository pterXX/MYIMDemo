//
//  IMBaseRequest.h
//  IMChat
//
//  Created by 徐世杰 on 2017/7/13.
//  Copyright © 2017年 徐世杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMRequestMacros.h"

@class IMResponse;
@interface IMBaseRequest : NSObject

#pragma mark - 基本请求参数
/// 请求的url，可以不包含域名（域名在IMNetworkConfig中指定）
@property (nonatomic, strong) NSString *url;

/// 请求方式
@property (nonatomic, assign) IMRequestMethod requestMethod;

/// 参数
@property (nonatomic, strong) id parameters;
/// header
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *headerField;

/// 请求成功回调
@property (nonatomic, copy) IMRequestCompletionBlock successAction;
/// 请求失败回调
@property (nonatomic, copy) IMRequestCompletionBlock failureAction;
/// 请求回调
@property (nonatomic, weak) id<IMRequestDelegate> delegate;

#pragma mark - 参数序列化类型
/// 请求参数序列化类型
@property (nonatomic, assign) IMRequestSerializerType requestSerializerType;
/// 响应参数序列化类型
@property (nonatomic, assign) IMResponseSerializerType responseSerializerType;

#pragma mark - 网络请求配置
/// 优先级
@property (nonatomic, assign) IMRequestPriority requestPriority;
/// 超时时间，默认获取IMNetworkConfig中的设置（30s）
@property (nonatomic, assign) NSTimeInterval timeoutInterval;
/// 不允许蜂窝数据访问
@property (nonatomic, assign) BOOL disableCellularAccess;

#pragma mark - 公开参数
/// 请求标识
@property (nonatomic, assign) NSInteger tag;
/// 用户自定义信息
@property (nonatomic, strong) id userInfo;
/// 网络请求状态
@property (nonatomic, assign, readonly) IMRequestState state;

/// 请求任务sessionTask
@property (nonatomic, strong) NSURLSessionTask *requestTask;

#pragma mark - MOCK
@property (nonatomic, assign) BOOL useMock;

#pragma mark - 初始化Request
/**
 * 初始化
 *
 * @param method 请求方式
 * @param url    url地址
 * @param parameters 请求参数
 */
- (instancetype)initWithMethod:(IMRequestMethod)method url:(NSString *)url parameters:(NSDictionary *)parameters;
/**
 * 类初始化方法
 */
+ (instancetype)requestWithMethod:(IMRequestMethod)method url:(NSString *)url parameters:(NSDictionary *)parameters;
- (instancetype)init __attribute__((unavailable("请使用 initWithMethod:url:params: 或者 requestWithMethod:url:params:")));

#pragma mark - 请求发起与终止
/**
 * 发起网络请求
 *
 * @param successAction 成功回调
 * @param failureAction 失败回调
 */
- (void)startRequestWithSuccessAction:(IMRequestCompletionBlock)successAction
                        failureAction:(IMRequestCompletionBlock)failureAction;

/**
 * 发起网络请求
 */
- (void)startRequest;

/**
 * 取消网络请求
 */
- (void)cancelRequest;

@end
