//
//  IMMoreKeyboardItem.m
//  IMChat
//
//  Created by 李伯坤 on 16/2/18.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "IMMoreKeyboardItem.h"

@implementation IMMoreKeyboardItem


+ (IMMoreKeyboardItem *)createByType:(IMMoreKeyboardItemType)type title:(NSString *)title imagePath:(NSString *)imagePath
{
    IMMoreKeyboardItem *item = [[IMMoreKeyboardItem alloc] init];
    item.type = type;
    item.title = title;
    item.imagePath = imagePath;
    return item;
}

@end
