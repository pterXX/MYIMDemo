//
//  IMSettingItem.m
//  IMChat
//
//  Created by 李伯坤 on 16/2/7.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "IMSettingItem.h"

@implementation IMSettingItem

+ (IMSettingItem *)createItemWithtitle:(NSString *)title
{
    IMSettingItem *item = [[IMSettingItem alloc] init];
    item.title = title;
    return item;
}

- (id)init
{
    if (self = [super init]) {
        self.showDisclosureIndicator = YES;
    }
    return self;
}

- (NSString *) cellClassName
{
    switch (self.type) {
        case IMSettingItemTypeDefalut:
            return @"IMSettingCell";
            break;
        case IMSettingItemTypetitleButton:
            return @"IMSettingButtonCell";
            break;
        case IMSettingItemTypeSwitch:
            return @"IMSettingSwitchCell";
            break;
        default:
            break;
    }
    return nil;
}

@end
