//
//  UIFont+IMChat.m
//  MYIMDemo
//
//  Created by 徐世杰 on 2019/3/1.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "UIFont+IMChat.h"


@implementation UIFont (IMChat)

+ (UIFont *) fontNavBarTitle
{
    return [UIFont systemFontOfSize:KSystemFontOfSize14];
}

+ (UIFont *) fontLoginLogo{
    return [UIFont fontWithName:@"MarkerFelt-Thin" size:KSystemFontOfSize50];
}

+ (UIFont *) fontLoginUserAndPassword{
    return [UIFont systemFontOfSize:KSystemFontOfSize16];
}


+ (UIFont *) fontMessageListUpdateTime{
    return [UIFont systemFontOfSize:KSystemFontOfSize12];
}

+ (UIFont *) fontMessageListTitle{
    return [UIFont systemFontOfSize:KSystemFontOfSize16];
}

+ (UIFont *) fontMessageListBadgeNumber{
    return [UIFont systemFontOfSize:KSystemFontOfSize12];
}
@end
