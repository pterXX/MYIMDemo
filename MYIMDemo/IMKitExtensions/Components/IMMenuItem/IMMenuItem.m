//
//  IMMenuItem.m
//  IMChat
//
//  Created by 李伯坤 on 2017/7/17.
//  Copyright © 2017年 李伯坤. All rights reserved.
//

#import "IMMenuItem.h"
#import <TLTabBarController/TLBadge.h>

IMMenuItem *createMenuItem(NSString *icon, NSString *title)
{
    IMMenuItem *item = [[IMMenuItem alloc] init];
    [item setIconName:icon];
    [item setTitle:title];
    return item;
}

@implementation IMMenuItem

- (void)setBadge:(NSString *)badge
{
    _badge = badge;
    _badgeSize = [TLBadge badgeSizeWithValue:badge];
}

- (void)setRightIconURL:(NSString *)rightIconURL withRightIconBadge:(BOOL)rightIconBadge
{
    [self setRightIconURL:rightIconURL];
    [self setShowRightIconBadge:rightIconBadge];
}

- (BOOL)showRightIconBadge
{
    if (!self.rightIconURL) {
        return NO;
    }
    return _showRightIconBadge;
}

@end
