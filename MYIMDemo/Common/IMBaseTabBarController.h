//
//  IMBaseTabBarController.h
//  MYIMDemo
//
//  Created by admin on 2019/3/8.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^IMBaseTabBarCtrSubVcAction)(UITabBarItem *item,UITabBarController *tabbarVc);
@interface IMBaseTabBarController : UITabBarController

@end


@interface IMBaseTabBarController(Class)
- (void)addSubController:( UIViewController * _Nonnull )vc action:(_Nonnull IMBaseTabBarCtrSubVcAction)action;
@end
NS_ASSUME_NONNULL_END
