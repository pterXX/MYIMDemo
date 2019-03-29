//
//  NSHTTPURLResponse+IMNetwork.h
//  IMChat
//
//  Created by 徐世杰 on 2017/7/14.
//  Copyright © 2017年 徐世杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSHTTPURLResponse (IMNetwork)

/// 字符串编码，默认NSUTF8StringEncoding
@property (nonatomic, assign, readonly) NSStringEncoding stringEncoding;

@end
