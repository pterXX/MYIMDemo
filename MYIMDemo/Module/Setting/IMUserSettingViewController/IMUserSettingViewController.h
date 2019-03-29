//
//  IMUserSettingViewController.h
//  MYIMDemo
//
//  Created by admin on 2019/3/18.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "IMBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface IMUserSettingViewController : IMBaseViewController
@property (nonatomic, strong, readonly) IMUser *userModel;

- (instancetype)initWithUserModel:(IMUser *)userModel;
- (instancetype)init  __attribute__((unavailable("请使用 initWithUserModel:")));
@end

NS_ASSUME_NONNULL_END
