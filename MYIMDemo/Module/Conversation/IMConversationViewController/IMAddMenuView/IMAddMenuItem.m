//
//  IMAddMenuItem.m
//  IMChat
//
//  Created by 徐世杰 on 16/3/11.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "IMAddMenuItem.h"

@implementation IMAddMenuItem

+ (IMAddMenuItem *)createWithType:(IMAddMneuType)type title:(NSString *)title iconPath:(NSString *)iconPath className:(NSString *)className
{
    IMAddMenuItem *item = [[IMAddMenuItem alloc] init];
    item.type = type;
    item.title = title;
    item.iconPath = iconPath;
    item.className = className;
    return item;
}

@end
