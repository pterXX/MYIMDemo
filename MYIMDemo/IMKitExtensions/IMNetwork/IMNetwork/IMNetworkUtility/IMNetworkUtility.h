//
//  IMNetworkUtility.h
//  IMChat
//
//  Created by 徐世杰 on 2017/7/14.
//  Copyright © 2017年 徐世杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBaseRequest.h"

@interface IMNetworkUtility : NSObject

+ (NSString *)requestMethodStringByMethod:(IMRequestMethod)method;

+ (NSString *)sharedCookie;

@end
