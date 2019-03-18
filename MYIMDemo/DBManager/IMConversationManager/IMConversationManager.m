//
//  IMConversationManager.m
//  MYIMDemo
//
//  Created by admin on 2019/3/18.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "IMConversationManager.h"

@implementation IMConversationManager
+ (IMConversationManager *)sharedManager{
    static IMConversationManager *helper;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        helper = [[IMConversationManager alloc] init];
    });
    return helper;
};
@end
