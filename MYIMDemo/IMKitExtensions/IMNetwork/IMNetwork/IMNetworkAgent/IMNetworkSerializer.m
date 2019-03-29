//
//  IMNetworkSerializer.m
//  IMChat
//
//  Created by 徐世杰 on 2017/7/14.
//  Copyright © 2017年 徐世杰. All rights reserved.
//

#import "IMNetworkSerializer.h"


@implementation IMNetworkSerializer
@synthesize allStatusCodes = _allStatusCodes;
@synthesize httpRequestSerializer = _httpRequestSerializer;
@synthesize jsonRequestSerializer = _jsonRequestSerializer;
@synthesize plistRequestSerializer = _plistRequestSerializer;
@synthesize httpResponseSerializer = _httpResponseSerializer;
@synthesize jsonResponseSerializer = _jsonResponseSerializer;
@synthesize xmlResponseSerializer = _xmlResponseSerializer;
@synthesize plistResponseSerializer = _plistResponseSerializer;

+ (void)load
{
    NSSet *acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    [AFHTTPSessionManager manager].responseSerializer.acceptableContentTypes = acceptableContentTypes;
}

+ (IMNetworkSerializer *)sharedInstance
{
    static IMNetworkSerializer *serializer;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serializer = [[self alloc] init];
    });
    return serializer;
}

#pragma mark - # Request
- (AFHTTPRequestSerializer *)httpRequestSerializer
{
    if (!_httpRequestSerializer) {
        _httpRequestSerializer = [AFHTTPRequestSerializer serializer];
    }
    return _httpRequestSerializer;
}

- (AFJSONRequestSerializer *)jsonRequestSerializer
{
    if (!_jsonRequestSerializer) {
        _jsonRequestSerializer = [AFJSONRequestSerializer serializer];
    }
    return _jsonRequestSerializer;
}

- (AFPropertyListRequestSerializer *)plistRequestSerializer
{
    if (!_plistRequestSerializer) {
        _plistRequestSerializer = [AFPropertyListRequestSerializer serializer];
    }
    return _plistRequestSerializer;
}

+ (AFHTTPRequestSerializer *)requestSerializerWithType:(IMRequestSerializerType)type
{
    IMNetworkSerializer *serializer = [IMNetworkSerializer sharedInstance];
    switch (type) {
        case IMRequestSerializerTypeHTTP:
            return serializer.httpRequestSerializer;
        case IMRequestSerializerTypeJSON:
            return serializer.jsonRequestSerializer;
        case IMRequestSerializerTypePLIST:
            return serializer.plistRequestSerializer;
        default:
            break;
    }
    return serializer.jsonRequestSerializer;
}

#pragma mark - # Response
- (AFHTTPResponseSerializer *)httpResponseSerializer
{
    if (!_httpResponseSerializer) {
        _httpResponseSerializer = [AFHTTPResponseSerializer serializer];
        [_httpResponseSerializer setAcceptableStatusCodes:self.allStatusCodes];
    }
    return _httpResponseSerializer;
}

- (AFJSONResponseSerializer *)jsonResponseSerializer
{
    if (!_jsonResponseSerializer) {
        _jsonResponseSerializer = [AFJSONResponseSerializer serializer];
        _jsonResponseSerializer.acceptableStatusCodes = self.allStatusCodes;
        [_jsonResponseSerializer setAcceptableStatusCodes:self.allStatusCodes];
    }
    return _jsonResponseSerializer;
}

- (AFXMLParserResponseSerializer *)xmlResponseSerializer
{
    if (!_xmlResponseSerializer) {
        _xmlResponseSerializer = [AFXMLParserResponseSerializer serializer];
        [_xmlResponseSerializer setAcceptableStatusCodes:self.allStatusCodes];
    }
    return _xmlResponseSerializer;
}

- (AFPropertyListResponseSerializer *)plistResponseSerializer
{
    if (!_plistResponseSerializer) {
        _plistResponseSerializer = [AFPropertyListResponseSerializer serializer];
        [_plistResponseSerializer setAcceptableStatusCodes:self.allStatusCodes];
    }
    return _plistResponseSerializer;
}

+ (AFHTTPResponseSerializer *)responseSerializerWithType:(IMResponseSerializerType)type
{
    IMNetworkSerializer *serializer = [IMNetworkSerializer sharedInstance];
    switch (type) {
        case IMResponseSerializerTypeHTTP:
            return serializer.httpResponseSerializer;
        case IMResponseSerializerTypeJSON:
            return serializer.jsonResponseSerializer;
        case IMResponseSerializerTypeXML:
            return serializer.xmlResponseSerializer;
        default:
            break;
    }
    return serializer.jsonResponseSerializer;
}

#pragma mark - # Getters
/// 所有网络请求响应吗
- (NSIndexSet *)allStatusCodes
{
    if (!_allStatusCodes) {
        /** 
         * 100~199 信息提示
         * 200~299 成功
         * 300~399 重定向
         * 400~499 客户端错误
         * 500~599 服务器错误
         */
        _allStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 599)];
    }
    return _allStatusCodes;
}


@end
