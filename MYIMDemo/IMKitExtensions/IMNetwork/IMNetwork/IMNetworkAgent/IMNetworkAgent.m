//
//  IMNetworkAgent.m
//  IMChat
//
//  Created by 徐世杰 on 2017/7/13.
//  Copyright © 2017年 徐世杰. All rights reserved.
//

#import "IMBaseRequest+Private.h"
#import "IMDownloadRequest.h"
#import "IMNetworkAgent.h"
#import "IMNetworkConfig.h"
#import "IMResponse.h"
#import "IMUploadRequest.h"
#import "NSMutableURLRequest+IMNetwork.h"
#import "NSString+IMNetwork.h"
#import <AFNetworking/AFNetworking.h>

NSString * const IMNetworkAgenIMockName = @"com.lbk.IMKit.IMNetwork.IMNetworkAgent.lock";

@interface IMNetworkAgent ()

@property (nonatomic, strong) IMNetworkConfig *networkConfig;

/// 请求队列
@property (nonatomic, strong) dispatch_queue_t networkQueue;
/// 锁
@property (nonatomic, strong) NSLock *lock;

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

/// 网络请求记录
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, __kindof IMBaseRequest *> *requestQueue;

@end

@implementation IMNetworkAgent

+ (instancetype)sharedAgent
{
    static IMNetworkAgent *agent;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        agent = [[self alloc] init];
    });
    return agent;
}

#pragma mark - # Public Methods
- (void)addRequest:(__kindof IMBaseRequest *)request
{
    NSParameterAssert(request != nil);
    NSURLRequest *customURLRequest = request.customURLRequest;
    // customURLRequest获取失败，请求结束
    if (!customURLRequest) {
        IMResponse *response = [[IMResponse alloc] initWithRequest:request
                                                      responseData:nil
                                                             error:[NSError errorWithDomain:NSURLErrorDomain code:0 userInfo:@{@"error" : @"customURLRequest is nil"}]];
        [self requestDidFinishedWithResponse:response];
        return;
    }
    
    NSError * __autoreleasing requestSerializationError = nil;
    __block NSURLSessionDataTask *dataTask = nil;
    if ([request isKindOfClass:[IMUploadRequest class]]) {
        IMUploadRequest *uploadRequest = request;
        dataTask = [self.sessionManager uploadTaskWithStreamedRequest:customURLRequest
                                                             progress:uploadRequest.uploadProgressAction
                                                    completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                                        [self handleRequestResult:dataTask responseObject:responseObject error:error];
                                                    }];
    }
    else if ([request isKindOfClass:[IMDownloadRequest class]]) {
//        IMDownloadRequest *downloadRequest = request;
        
    }
    else {
        dataTask = [self.sessionManager dataTaskWithRequest:customURLRequest
                                          completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                              [self handleRequestResult:dataTask responseObject:responseObject error:error];
                                          }];
    }
    request.requestTask = dataTask;

    if (requestSerializationError || !request.requestTask) {
        IMResponse *response = [[IMResponse alloc] initWithRequest:request responseData:nil error:requestSerializationError];
        [self requestDidFinishedWithResponse:response];
        return;
    }

    [self p_addRequestToQueue:request];
    [request.requestTask resume];
}

- (void)cancelRequest:(__kindof IMBaseRequest *)request
{
    NSParameterAssert(request != nil);
    [request.requestTask cancel];
    [self p_removeRequestFromQueue:request];
}

- (void)cancelAllRequests
{
    [self.lock lock];
    NSArray *allKeys = [[self.requestQueue allKeys] copy];
    [self.lock unlock];
    for (NSNumber *key in allKeys) {
        [self.lock lock];
        IMBaseRequest *request = self.requestQueue[key];
        [self.lock unlock];
        [request cancelRequest];
    }
}

- (NSArray<__kindof IMBaseRequest *> *)allRequests
{
    return self.requestQueue.allValues.copy;
}

#pragma mark - # Request
/// 网络请求得到响应
- (void)handleRequestResult:(NSURLSessionTask *)task responseObject:(id)responseObject error:(NSError *)error
{
    // 获取request模型
    [self.lock lock];
    IMBaseRequest *request = self.requestQueue[@(task.taskIdentifier)];
    [self.lock unlock];
    if (!request) {
        NSLog(@"IMNetwork: 请求结束时request获取失败");
        return;
    }

    // 构建response模型并执行回调
    IMResponse *response = [[IMResponse alloc] initWithRequest:request responseData:responseObject error:error];
    [self requestDidFinishedWithResponse:response];

    // 将request从队列中删除
    dispatch_async(dispatch_get_main_queue(), ^{
        [self p_removeRequestFromQueue:request];
    });
}

/// 网络请求结束，根据response执行回调
- (void)requestDidFinishedWithResponse:(IMResponse *)response
{
    dispatch_async(dispatch_get_main_queue(), ^{
        IMBaseRequest *request = response.request;
        if (response.success) {     // 成功
            if (request.delegate != nil && [request.delegate respondsToSelector:@selector(requestSuccess:withResponseModel:)]) {
                [request.delegate requestSuccess:request withResponseModel:response];
            }
            if (request.successAction) {
                request.successAction(response);
            }
        }
        else {      // 失败
            if (request.delegate != nil && [request.delegate respondsToSelector:@selector(requestFailure:withResponseModel:)]) {
                [request.delegate requestFailure:request withResponseModel:response];
            }
            if (request.failureAction) {
                request.failureAction(response);
            }
        }
        [request setSuccessAction:nil];
        [request setFailureAction:nil];
    });
}

#pragma mark - # Private Methods
- (void)p_addRequestToQueue:(__kindof IMBaseRequest *)request
{
    [self.lock lock];
    [self.requestQueue setObject:request forKey:@(request.requestTask.taskIdentifier)];
    [self.lock unlock];
}

- (void)p_removeRequestFromQueue:(__kindof IMBaseRequest *)request {
    [self.lock lock];
    [self.requestQueue removeObjectForKey:@(request.requestTask.taskIdentifier)];
    [self.lock unlock];
}

#pragma mark - # Getters
- (IMNetworkConfig *)networkConfig
{
    return [IMNetworkConfig sharedConfig];
}

- (AFHTTPSessionManager *)sessionManager
{
    if (!_sessionManager) {
        _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:self.networkConfig.baseURL.toURL sessionConfiguration:self.networkConfig.sessionConfiguration];
        [_sessionManager setSecurityPolicy:[IMNetworkConfig sharedConfig].securityPolicy];
        [_sessionManager setCompletionQueue:self.networkQueue];
    }
    return _sessionManager;
}

- (NSMutableDictionary<NSNumber *, __kindof IMBaseRequest *> *)requestQueue
{
    if (!_requestQueue) {
        _requestQueue = [[NSMutableDictionary alloc] init];
    }
    return _requestQueue;
}

- (dispatch_queue_t)networkQueue
{
    if (!_networkQueue) {
        _networkQueue = dispatch_queue_create(IMNetworkQueueName, DISPATCH_QUEUE_CONCURRENT);
    }
    return _networkQueue;
}

- (NSLock *)lock
{
    if (!_lock) {
        _lock = [[NSLock alloc] init];
        [_lock setName:IMNetworkAgenIMockName];
    }
    return _lock;
}

@end
