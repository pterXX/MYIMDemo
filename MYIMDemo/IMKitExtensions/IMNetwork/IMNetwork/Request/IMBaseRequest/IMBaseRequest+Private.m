//
//  IMBaseRequest+Private.m
//  IMChat
//
//  Created by 徐世杰 on 2017/7/14.
//  Copyright © 2017年 徐世杰. All rights reserved.
//

#import "IMBaseRequest+Private.h"
#import "IMNetworkConfig.h"
#import "IMNetworkSerializer.h"
#import "IMNetworkUtility.h"
#import "NSString+IMNetwork.h"

@implementation IMBaseRequest (Private)

- (NSString *)requestMethodString
{
    return [IMNetworkUtility requestMethodStringByMethod:self.requestMethod];
}

- (NSString *)requestURL
{
    NSString *requestURL = self.url;
    NSURL *url = requestURL.toURL;
    
    // 处理不完整的url
    if (!(url && url.host && url.scheme)) {
        if (self.baseURL.length > 0 && ![self.baseURL hasSuffix:@"/"]) {
            requestURL = [url URLByAppendingPathComponent:@""].absoluteString;
        }
        else {
            requestURL = [NSURL URLWithString:self.url relativeToURL:url].absoluteString;
        }
    }
    
    // 使用mock接口
    if (self.useMock) {
        NSString *apiName = url.lastPathComponent;
        requestURL = [NSString stringWithFormat:@"%@/%@", [IMNetworkConfig sharedConfig].mockBaseURL, apiName];
    }
    
    // https相关
    if ([[IMNetworkConfig sharedConfig].mainScheme isEqualToString:IMURLSchemeHTTPS]) {
        requestURL = [url.absoluteString httpsUrl];
    }
    else if ([[IMNetworkConfig sharedConfig].mainScheme isEqualToString:IMURLSchemeHTTPS]) {
        requestURL = [url.absoluteString httpsUrl];
    }
    
    return [requestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSURLRequest *)customURLRequest
{
    NSError * __autoreleasing requestSerializationError = nil;
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:self.requestMethodString URLString:self.requestURL parameters:self.parameters error:&requestSerializationError];;
    if (requestSerializationError) {
        NSLog(@"IMNetwork: IMBaseRequest序列化失败");
    }
    
    NSString *sharedCookie = [IMNetworkUtility sharedCookie];
    if (sharedCookie.length > 0) {
        [request addValue:sharedCookie forHTTPHeaderField:@"Cookie"];
    }

    return request;
}

- (NSString *)baseURL
{
    return [IMNetworkConfig sharedConfig].baseURL;
}

- (AFHTTPRequestSerializer *)requestSerializer
{
    AFHTTPRequestSerializer *requestSerializer = [IMNetworkSerializer requestSerializerWithType:self.requestSerializerType];
    requestSerializer.timeoutInterval = self.timeoutInterval;
    requestSerializer.allowsCellularAccess = !self.disableCellularAccess;
    for (NSString *key in self.headerField.allKeys) {
        NSString *value = [self.headerField valueForKey:key];
        [requestSerializer setValue:value forHTTPHeaderField:key];
    }
    
    return requestSerializer;
}

@end
