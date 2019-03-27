//
//  NSURL+IMNetwork.m
//  IMChat
//
//  Created by 李伯坤 on 2017/7/13.
//  Copyright © 2017年 李伯坤. All rights reserved.
//

#import "NSURL+IMNetwork.h"

@implementation NSURL (IMNetwork)

- (BOOL)isHttpURL
{
    return [self.absoluteString hasPrefix:@"http:"];
}

- (BOOL)isHttpsURL
{
    return [self.absoluteString hasPrefix:@"https:"];
}

@end
