//
//  UIColor+IMChat.m
//  MYIMDemo
//
//  Created by 徐世杰 on 2019/3/1.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "UIColor+IMChat.h"
#import "IMColorTools.h"
@implementation UIColor (IMChat)

#pragma mark - # 字体
+ (UIColor *)colorTextBlack {
    return [UIColor blackColor];
}

+ (UIColor *)colorTextGray {
    return [UIColor grayColor];
}

+ (UIColor *)colorTextlightGrayColor {
    return [UIColor lightGrayColor];
}

+ (UIColor *)colorTextGray1 {
    return SETCOLOR(160, 160, 160, 1.0);
}

#pragma mark - 灰色
+ (UIColor *)colorGrayBG {
    return SETCOLOR(239.0, 239.0, 244.0, 1.0);
}

+ (UIColor *)colorGrayCharcoalBG {
    return SETCOLOR(235.0, 235.0, 235.0, 1.0);
}

+ (UIColor *)colorGrayLine {
    return [UIColor colorWithWhite:0.5 alpha:0.3];
}

+ (UIColor *)colorGrayForChatBar {
    return SETCOLOR(245.0, 245.0, 247.0, 1.0);
}

+ (UIColor *)colorGrayForMoment {
    return SETCOLOR(243.0, 243.0, 245.0, 1.0);
}




#pragma mark - 绿色
+ (UIColor *)colorGreenDefault {
    return SETCOLOR(2.0, 187.0, 0.0, 1.0f);
}

+ (UIColor *)colorGreenHL {
    return SETCOLOR(46, 139, 46, 1.0f);
}

#pragma mark - 蓝色
+ (UIColor *)colorBlueMoment {
    return SETCOLOR(74.0, 99.0, 141.0, 1.0);
}

+ (UIColor *)colorBlueImagePicker{
    return SETCOLOR(0, 140, 224, 1.0);
}

#pragma mark - 黑色
+ (UIColor *)colorBlackForNavBar {
    return SETCOLOR(20.0, 20.0, 20.0, 1.0);
}

+ (UIColor *)colorBlackBG {
    return SETCOLOR(46.0, 49.0, 50.0, 1.0);
}

+ (UIColor *)colorBlackAlphaScannerBG {
    return [UIColor colorWithWhite:0 alpha:0.6];
}

+ (UIColor *)colorBlackForAddMenu {
    return SETCOLOR(71, 70, 73, 1.0);
}

+ (UIColor *)colorBlackForAddMenuHL {
    return SETCOLOR(65, 64, 67, 1.0);
}


#pragma mark - #
+ (UIColor *)colorRedForButton {
    return SETCOLOR(228, 68, 71,1.0);
}

+ (UIColor *)colorRedForButtonHL {
    return SETCOLOR(205, 62, 64,1.0);
}
@end
