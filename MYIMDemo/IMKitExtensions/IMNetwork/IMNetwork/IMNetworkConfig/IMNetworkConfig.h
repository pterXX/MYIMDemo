//
//  IMNetworkConfig.h
//  IMChat
//
//  Created by 徐世杰 on 2017/7/13.
//  Copyright © 2017年 徐世杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMRequestMacros.h"

#define     IMNetworkRequestTimeoutInterval     30.0f
#define     IMURLSchemeHTTP                     @"http"
#define     IMURLSchemeHTTPS                    @"https"

@class AFSecurityPolicy;
@interface IMNetworkConfig : NSObject

+ (IMNetworkConfig *)sharedConfig;

/// 域名
@property (nonatomic, strong, readonly) NSString *baseURL;
/// mock域名
@property (nonatomic, strong, readonly) NSString *mockBaseURL;

/// header
@property (nonatomic, strong, readonly) NSDictionary<NSString *, NSString *> *headerField;
/// 安全策略，默认http
@property (nonatomic, strong, readonly) AFSecurityPolicy *securityPolicy;
/// URL Session配置
@property (nonatomic, strong, readonly) NSURLSessionConfiguration *sessionConfiguration;
/// 使用的http（https）方案
@property (nonatomic, strong, readonly) NSString *mainScheme;
/// 超时时间
@property (nonatomic, assign, readonly) NSTimeInterval timeoutIntervalForRequest;

/// 默认请求参数序列化类型
@property (nonatomic, assign, readonly) IMRequestSerializerType requestSerializerType;
/// 默认响应参数序列化类型
@property (nonatomic, assign,readonly) IMResponseSerializerType responseSerializerType;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end
