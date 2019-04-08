//
//  UIDevice+Category.m
//  proj
//
//  Created by asdasd on 2017/12/21.
//  Copyright © 2017年 asdasd. All rights reserved.
//

#import "UIDevice+Category.h"

@implementation UIDevice (Category)

+ (NSString *)identifierNumber{
    //手机别名： 用户定义的名称
    static NSString* identifierNumber = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //手机序列号
        identifierNumber = [NSString stringWithFormat:@"%ld",[[UIDevice currentDevice] userInterfaceIdiom]];
    });
    return identifierNumber;
}

+ (NSString *)userPhoneName{
    //手机别名： 用户定义的名称
    static NSString* userPhoneName = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userPhoneName = [[UIDevice currentDevice] name];
        NSLog(@"手机别名: %@", userPhoneName);
    });
    
    return userPhoneName;
}

+ (NSString *)deviceName{
    //设备名称
    static NSString* deviceName = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        deviceName = [[UIDevice currentDevice] systemName];
        NSLog(@"设备名称: %@",deviceName );
    });
    
    return deviceName;
}

+ (NSString *)currentSystemVersion{
    //手机系统版本
    static NSString* phoneVersion = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        phoneVersion = [[UIDevice currentDevice] systemVersion];
    });
    
    //    NSLog(@"手机系统版本: %@", phoneVersion);
    return phoneVersion;
}


+ (NSString *)phoneModel{
    //手机型号
    static NSString* phoneModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        phoneModel = [[UIDevice currentDevice] model];
    });
    
    //    NSLog(@"手机型号: %@",phoneModel );
    return phoneModel;
}

+ (NSString *)localPhoneModel{
    //地方型号  （国际化区域名称）
    static NSString* localPhoneModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        localPhoneModel = [[UIDevice currentDevice] localizedModel];
    });
    //    NSLog(@"国际化区域名称: %@",localPhoneModel );
    return localPhoneModel;
}


+ (NSString *)appCurName{
    static NSString *appCurName = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        // 当前应用名称
        appCurName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    });
    return appCurName;
}


+ (NSString *)appCurVersion{
    static NSString *appCurVersion = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        // 当前应用名称
        appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    });
    return appCurVersion;
}


+ (NSString *)appCurVersionNum{
    static NSString *appCurVersionNum = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        // 当前应用版本号码   int类型
        appCurVersionNum = [infoDictionary objectForKey:@"CFBundleVersion"];
    });
    return appCurVersionNum;
}


+ (BOOL)isPhoneXLater {
    
    BOOL iPhoneXLater = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {//判断是否是手机
        return iPhoneXLater;
    }
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            iPhoneXLater = YES;
        }
    }
    return iPhoneXLater;
}


@end
