//
//  NSURL+IMNetwork.m
//  IMChat
//
//  Created by 徐世杰 on 2017/7/13.
//  Copyright © 2017年 徐世杰. All rights reserved.
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
