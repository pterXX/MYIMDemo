//
//  UIDevice+Category.h
//  proj
//
//  Created by asdasd on 2017/12/21.
//  Copyright © 2017年 asdasd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (Category)
+ (NSString *)appCurName; // 当前应用名称
+ (NSString *)appCurVersion; // 当前应用软件版本  比如：1.0.1
+ (NSString *)appCurVersionNum;
+ (NSString *)deviceName; // 设备名称
+ (NSString *)identifierNumber; //手机序列号
+ (NSString *)localPhoneModel; //地方型号  （国际化区域名称）
+ (NSString *)phoneModel; // 手机型号
+ (NSString *)currentSystemVersion; //  系统版本
+ (NSString *)userPhoneName; //  手机别名

//  判断是否是iPhoneX以后有刘海的机型
+(BOOL)isPhoneXLater;

@end
