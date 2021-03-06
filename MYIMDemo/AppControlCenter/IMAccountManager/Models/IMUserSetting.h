//
//  IMUserSetting.h
//  IMChat
//
//  Created by 徐世杰 on 16/3/22.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMUserSetting : NSObject

@property (nonatomic, strong) NSString *userID;

@property (nonatomic, assign) BOOL star;

@property (nonatomic, assign) BOOL dismissTimeLine;

@property (nonatomic, assign) BOOL prohibitTimeLine;

@property (nonatomic, assign) BOOL blackList;

@end
