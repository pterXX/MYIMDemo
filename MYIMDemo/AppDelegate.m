//
//  AppDelegate.m
//  MYIMDemo
//
//  Created by 徐世杰 on 2019/2/28.
//  Copyright © 2019 徐世杰. All rights reserved.
//

// Controller
#import "IMBaseNavigationController.h"
#import "IMBaseTabBarController.h"
#import "IMConversationViewController.h"
#import "IMLoginViewController.h"
// Other
#import "AppDelegate.h"
#if __has_include(<AVOSCloud/AVOSCloud.h>)
#import <AVOSCloud/AVOSCloud.h>
#endif

#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <sys/utsname.h>


@interface AppDelegate ()

@end

@implementation AppDelegate


- (NSString *)str{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    //当前手机所属运营商名称
    NSString *mobile;
    //先判断有没有SIM卡，如果没有则不获取本机运营商
    if (!carrier.isoCountryCode) {
        mobile = @"无运营商";
    }else{
        mobile = [carrier carrierName];
    }
    
    NSString * iponeM = [[UIDevice currentDevice] systemName];
    
    NSString *bundleIdentifie = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    

    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    NSString * preferredLang = [allLanguages objectAtIndex:0];
    
    NSString *UUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width * [UIScreen mainScreen].scale;
    CGFloat height = [UIScreen mainScreen].bounds.size.height * [UIScreen mainScreen].scale;
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    
    CGFloat batteryLevel = [[UIDevice currentDevice] batteryLevel];
    
    NSString *str = [NSString stringWithFormat:@"\n\
    ----------------------------------------------------------\n \
    当前时间:%@\n \
    运营商: %@\n \
    系统名称: %@ \n \
    包名: %@ \n \
    当前语言: %@ \n \
    app名称: %@ \n \
    设备ID: %@ \n \
    分辨率:%@ * %@ \n \
    设备型号: %@ \n \
    系统版本: %@ \n \
    剩余电量:%@ \n \
    ----------------------------------------------------------",[NSDate date],mobile,iponeM,bundleIdentifie,preferredLang,appName,UUID,@(width),@(height),platform,phoneVersion,@(batteryLevel)];
    return str;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    
    NSLog(@"%@",[self str]);
    
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    // 初始化UI
    [[IMLaunchManager sharedInstance] launchInWindow:self.window];
    
    //  初始化xmpp,默认打开手动验证证书
    KIMXMPPHelper.customCertEvaluation = YES;
    //  是否以base64的方式传文件
//    KIMXMPPHelper.fileUploadIsBase64 = YES;
    //  文件上传的方法
    [KIMXMPPHelper setImageUploadBlock:^(UIImage * _Nonnull image, void (^ _Nonnull handleBlock)(NSString * _Nonnull,NSData *imageData)) {
        @autoreleasepool {
            //  压缩图片并上传
            [image compressedWithImageKilobyte:500 imageBlock:^(NSData *imageData) {
                AVFile *file = [AVFile fileWithData:imageData];
                [file uploadWithCompletionHandler:^(BOOL succeeded, NSError * _Nullable error) {
                    NSLog(@"成功  %@", file.url);//返回一个唯一的 Url 地址
                    if (succeeded) {
                        handleBlock(file.url,imageData);
                        NSLog(@"图片上传成功");
                    }else{
                        NSLog(@"上传失败");
                    }
                }];
            }];
        }
    }];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
