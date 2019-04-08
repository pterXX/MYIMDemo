//
//  NSHTTPURLResponse+IMNetwork.m
//  IMChat
//
//  Created by 徐世杰 on 2017/7/14.
//  Copyright © 2017年 徐世杰. All rights reserved.
//

#import "NSHTTPURLResponse+IMNetwork.h"

@implementation NSHTTPURLResponse (IMNetwork)

- (NSStringEncoding)stringEncoding
{
    if (self.textEncodingName) {
        CFStringEncoding encoding = CFStringConvertIANACharSetNameToEncoding((CFStringRef)self.textEncodingName);
        if (encoding != kCFStringEncodingInvalidId) {
            return CFStringConvertEncodingToNSStringEncoding(encoding);
        }
    }
    return NSUTF8StringEncoding;
}

@end
