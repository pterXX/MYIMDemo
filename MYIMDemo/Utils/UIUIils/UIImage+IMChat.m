//
//  UIImage+IMChat.m
//  MYIMDemo
//
//  Created by 徐世杰 on 2019/3/1.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "UIImage+IMChat.h"

@implementation UIImage (IMChat)
+ (UIImage *)imageDefaultHeadPortrait{
    return  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"WechatIMG5" ofType:@"png"]];
}
@end
