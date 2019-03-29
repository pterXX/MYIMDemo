//
//  IMNetworkUtility.m
//  IMChat
//
//  Created by 徐世杰 on 2017/7/14.
//  Copyright © 2017年 徐世杰. All rights reserved.
//

#import "IMNetworkUtility.h"

@implementation IMNetworkUtility

+ (NSString *)requestMethodStringByMethod:(IMRequestMethod)method
{
    switch (method) {
        case IMRequestMethodGET:
            return @"GET";
        case IMRequestMethodPOST:
            return @"POST";
        case IMRequestMethodPUT:
            return @"PUT";
        case IMRequestMethodHEAD:
            return @"HEAD";
        case IMRequestMethodPATCH:
            return @"PATCH";
        case IMRequestMethodDELETE:
            return @"DELETE";
        case IMRequestMethodOPTIONS:
            return @"OPTIONS";
        case IMRequestMethodCONNECT:
            return @"CONNECT";
        case IMRequestMethodTRACE:
            return @"TRACE";
        default:
            break;
    }
    return @"GET";
}

+ (NSString *)sharedCookie
{
    return nil;
}


@end
