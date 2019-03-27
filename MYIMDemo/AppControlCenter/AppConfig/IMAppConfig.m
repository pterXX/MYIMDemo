//
//  IMAppConfig.m
//  IMChat
//
//  Created by 李伯坤 on 2017/9/20.
//  Copyright © 2017年 李伯坤. All rights reserved.
//

#import "IMAppConfig.h"
#import "IMAddMenuItem.h"

@implementation IMAppConfig

+ (IMAppConfig *)sharedConfig
{
    static IMAppConfig *config;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[self alloc] init];
    });
    return config;
}

#pragma mark - # Private Methos
- (IMAddMenuItem *)p_getMenuItemByType:(IMAddMneuType)type
{
    switch (type) {
        case IMAddMneuTypeGroupChat:        // 群聊
            return [IMAddMenuItem createWithType:IMAddMneuTypeGroupChat title:@"发起群聊" iconPath:@"nav_menu_groupchat" className:@""];
            break;
        case IMAddMneuTypeAddFriend:        // 添加好友
            return [IMAddMenuItem createWithType:IMAddMneuTypeAddFriend title:@"添加朋友" iconPath:@"nav_menu_addfriend" className:@"IMAddContactsViewController"];
            break;
        case IMAddMneuTypeWallet:           // 收付款
            return [IMAddMenuItem createWithType:IMAddMneuTypeWallet title:@"收付款" iconPath:@"nav_menu_wallet" className:@"IMWalletViewController"];
            break;
        case IMAddMneuTypeScan:             // 扫一扫
            return [IMAddMenuItem createWithType:IMAddMneuTypeScan title:@"扫一扫" iconPath:@"nav_menu_scan" className:@"IMScanningViewController"];
            break;
        default:
            break;
    }
    return nil;
}

#pragma mark - # Getters
- (NSString *)version
{
    NSString *shortVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *buildID = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *version = [NSString stringWithFormat:@"%@ (%@)", shortVersion, buildID];

    return version;
}

- (NSArray *)addMenuItems
{
    if (!_addMenuItems) {
        return @[[self p_getMenuItemByType:0],
                 [self p_getMenuItemByType:1],
                 [self p_getMenuItemByType:2],
                 [self p_getMenuItemByType:3],];
    }
    return _addMenuItems;
}

@end
