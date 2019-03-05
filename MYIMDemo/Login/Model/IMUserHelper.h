//
//  IMUserHelper.h
//  MYIMDemo
//
//  Created by admin on 2019/3/5.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface IMUserHelper : NSObject

@property (nonatomic, strong) IMUser *user;

@property (nonatomic, strong, readonly) NSString *userID;

@property (nonatomic, assign, readonly) BOOL isLogin;

+ (IMUserHelper *)sharedHelper;

- (void)loginTestAccount;

@end

NS_ASSUME_NONNULL_END
