//
//  AppDelegate.m
//  Demo
//
//  Created by admin on 2019/4/18.
//  Copyright © 2019 admin. All rights reserved.
//

#import "AppDelegate.h"
#import "BehaviorTitleViewController.h"

#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <sys/utsname.h>


@interface AppDelegate ()

@end

@implementation AppDelegate


- (NSString *)log{
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
    // Override point for customization after application launch.
    
    NSLog(@"%@",[self log]);
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    BehaviorTitleViewController *vc = [[BehaviorTitleViewController alloc] init];
    [self.window setRootViewController:[[UINavigationController alloc] initWithRootViewController:vc]];
    
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
