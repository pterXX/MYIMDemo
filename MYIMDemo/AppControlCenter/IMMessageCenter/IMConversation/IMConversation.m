//
//  IMConversation.m
//  IMChat
//
//  Created by 徐世杰 on 16/1/23.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "IMConversation.h"

@implementation IMConversation

- (BOOL)isRead
{
    return self.unreadCount <= 0;
}

- (NSString *)badgeValue
{
    if (self.isRead) {
        return nil;
    }
    if (self.convType == IMConversationTypePersonal || self.convType == IMConversationTypeGroup) {
        return self.unreadCount <= 99 ? @(self.unreadCount).stringValue : @"99+";
    }
    else {
        return @"";
    }
}

@end
