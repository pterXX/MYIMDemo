//
//  UIViewController+IMBaseNavigationController.m
//  MYIMDemo
//
//  Created by admin on 2019/3/27.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "UIViewController+IMBaseNavigationController.h"

@implementation UIViewController (IMBaseNavigationController)
+(IMBaseNavigationController *)navVc{
    if ([[self class] isKindOfClass:[IMBaseNavigationController class]]) {
        return [[[self class] alloc] init];
    }
    return [[IMBaseNavigationController alloc] initWithRootViewController:[[[self class] alloc] init]];
}
@end
