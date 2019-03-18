//
//  IMUserDetailViewController.h
//  MYIMDemo
//
//  Created by admin on 2019/3/15.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "IMFlexibleLayoutViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface IMUserDetailViewController : IMFlexibleLayoutViewController
- (instancetype)initWithUserId:(NSString *)userId;
- (instancetype)initWithUserModel:(IMUser *)userModel;
- (instancetype)init  __attribute__((unavailable("请使用 initWithUserId: 或 initWithUserModel:")));
@end

NS_ASSUME_NONNULL_END
