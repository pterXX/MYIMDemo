//
//  IMBaseRequest.m
//  IMChat
//
//  Created by 李伯坤 on 2017/7/13.
//  Copyright © 2017年 李伯坤. All rights reserved.
//

#import "IMBaseRequest.h"
#import "IMNetworkConfig.h"
#import "IMNetworkAgent.h"
#import "IMResponse.h"

#define     IM_NSURLSessionTaskPriorityHigh         0.75
#define     IM_NSURLSessionTaskPriorityLow          0.25
#define     IM_NSURLSessionTaskPriorityDefault      0.50

@implementation IMBaseRequest

+ (instancetype)requestWithMethod:(IMRequestMethod)method url:(NSString *)url parameters:(NSDictionary *)parameters
{
    return [[self alloc] initWithMethod:method url:url parameters:parameters];
}

- (instancetype)initWithMethod:(IMRequestMethod)method url:(NSString *)url parameters:(NSDictionary *)parameters
{
    if (self = [super init]) {
        self.requestMethod = method;
        self.url = url;
        self.parameters = parameters;
        self.requestPriority = IMRequestPriorityDefault;
        
        self.timeoutInterval = [IMNetworkConfig sharedConfig].timeoutIntervalForRequest;
        self.requestSerializerType = [IMNetworkConfig sharedConfig].requestSerializerType;
        self.responseSerializerType = [IMNetworkConfig sharedConfig].responseSerializerType;
        self.headerField = [IMNetworkConfig sharedConfig].headerField;
    }
    return self;
}

#pragma mark - # Public Methods
- (void)startRequestWithSuccessAction:(IMRequestCompletionBlock)successAction failureAction:(IMRequestCompletionBlock)failureAction
{
    [self setSuccessAction:successAction];
    [self setFailureAction:failureAction];
    [self startRequest];
}

- (void)startRequest
{
    [[IMNetworkAgent sharedAgent] addRequest:self];
}

- (void)cancelRequest
{
    [[IMNetworkAgent sharedAgent] cancelRequest:self];
}

- (void)setRequestTask:(NSURLSessionTask *)requestTask
{
    _requestTask = requestTask;
    
    // 在iOS8的一些系统上，直接使用NSURLSessionTaskPriorityHigh／Low／Default等值，由于编译器等的优化，会出现莫名其妙的崩溃，rdar地址：http://www.openradar.me/23956486 , 所以我们直接使用其float值
    if ([requestTask respondsToSelector:@selector(priority)]) {
        switch (self.requestPriority) {
            case IMRequestPriorityHigh:
                self.requestTask.priority = IM_NSURLSessionTaskPriorityHigh;
                break;
            case IMRequestPriorityLow:
                self.requestTask.priority = IM_NSURLSessionTaskPriorityLow;
                break;
            case IMRequestPriorityDefault:
                self.requestTask.priority = IM_NSURLSessionTaskPriorityDefault;
                break;
            default:
                self.requestTask.priority = IM_NSURLSessionTaskPriorityDefault;
                break;
        }
    }
}

#pragma mark - # Getters
- (IMRequestState)state
{
    if (!self.requestTask) {
        return IMRequestStateSuspended;
    }
    switch (self.requestTask.state) {
        case NSURLSessionTaskStateRunning:
            return IMRequestStateRunning;
        case NSURLSessionTaskStateSuspended:
            return IMRequestStateSuspended;
        case NSURLSessionTaskStateCanceling:
            return IMRequestStateCanceling;
        case NSURLSessionTaskStateCompleted:
            return IMRequestStateCompleted;
        default:
            break;
    }
    return IMRequestStateSuspended;
}

@end
