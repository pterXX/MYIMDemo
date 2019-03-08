//
//  IMChatBaseViewController.h
//  MYIMDemo
//
//  Created by 徐世杰 on 2019/3/1.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "IMBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface IMChatBaseViewController : IMBaseViewController

/**
 权限设置
 
 @param title 提示标题
 @param message 提示内容
 @param block 回调
 */
- (void)settingAuthorizationWithTitle:(NSString *)title message:(NSString *)message cancel:(void (^)(BOOL))block;

@end

NS_ASSUME_NONNULL_END
