//
//  UINavigationController+IMChat.m
//  IMChat
//
//  Created by 徐世杰 on 2017/9/20.
//  Copyright © 2017年 徐世杰. All rights reserved.
//

#import "UINavigationController+IMChat.h"

@implementation UINavigationController (IMChat)

+ (void)load
{
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont fontNavBarTitle]}];

    IMExchangeMethod(@selector(loadView), @selector(__tt_loadView));
}

- (void)__tt_loadView
{
    [self __tt_loadView];
    
    [self.navigationBar setBarTintColor:[UIColor colorBlackForNavBar]];
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    [self.view setBackgroundColor:[UIColor colorGrayBG]];
}

@end
