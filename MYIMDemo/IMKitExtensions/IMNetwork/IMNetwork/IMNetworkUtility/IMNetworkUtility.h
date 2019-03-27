//
//  IMNetworkUtility.h
//  IMChat
//
//  Created by 李伯坤 on 2017/7/14.
//  Copyright © 2017年 李伯坤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBaseRequest.h"

@interface IMNetworkUtility : NSObject

+ (NSString *)requestMethodStringByMethod:(IMRequestMethod)method;

+ (NSString *)sharedCookie;

@end
