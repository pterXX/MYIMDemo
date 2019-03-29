//
//  IMAppConfig.h
//  IMChat
//
//  Created by 徐世杰 on 2017/9/20.
//  Copyright © 2017年 徐世杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMAppConfig : NSObject

/// App 版本信息
@property (nonatomic, strong, readonly) NSString *version;

/// 消息页面，+菜单项
@property (nonatomic, strong) NSArray *addMenuItems;

+ (IMAppConfig *)sharedConfig;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end
