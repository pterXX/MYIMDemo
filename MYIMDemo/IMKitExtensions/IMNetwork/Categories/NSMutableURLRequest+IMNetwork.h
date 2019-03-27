//
//  NSMutableURLRequest+IMNetwork.h
//  IMChat
//
//  Created by 李伯坤 on 2017/7/14.
//  Copyright © 2017年 李伯坤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMRequestMacros.h"

@class AFHTTPRequestSerializer;
@interface NSMutableURLRequest (IMNetwork)

+ (NSMutableURLRequest *)tt_mutableURLRequestWithSerializer:(AFHTTPRequestSerializer *)serializer
                                                     method:(NSString *)method
                                                  URLString:(NSString *)urlString
                                                 parameters:(id)parameters
                                  constructingBodyWithBlock:(IMConstructingBlock)constructingBodyWithBlock
                                                      error:(NSError *__autoreleasing *)error;

@end
