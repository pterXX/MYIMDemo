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
    return [UIFont fontWithName:@"MarkerFelt-Thin" size:KSystemFontOfSize32];
}

+ (UIFont *) fontLoginSignUp{
    return [UIFont systemFontOfSize:KSystemFontOfSize14];
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

+ (UIFont *) fontContactItemName{
    return [UIFont systemFontOfSize:KSystemFontOfSize16];
}

+ (UIFont *) fontContactItemSubTitle{
    return [UIFont systemFontOfSize:KSystemFontOfSize14];
}

+ (UIFont *) fontConversationUsername
{
    return [UIFont systemFontOfSize:17.0f];
}

+ (UIFont *) fontConversationDetail
{
    return [UIFont systemFontOfSize:14.0f];
}

+ (UIFont *) fontConversationTime
{
    return [UIFont systemFontOfSize:12.5f];
}

+ (UIFont *)fontTextMessageText
{
    CGFloat size = [[NSUserDefaults standardUserDefaults] doubleForKey:@"CHAT_FONT_SIZE"];
    if (size == 0) {
        size = KSystemFontOfSize16;
    }
    return [UIFont systemFontOfSize:size];
}

@end
