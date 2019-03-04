//
//  IMSystemAuthorization.m
//  MYIMDemo
//
//  Created by 徐世杰 on 2019/3/1.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "IMSystemAuthorization.h"
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import "UIViewController+IMCategory.h"

@implementation IMSystemAuthorization
static IMSystemAuthorization *systemAuth = nil;

+(instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        systemAuth =  [[IMSystemAuthorization alloc] init];
    });
    return systemAuth;
}


/**第2步: 分配内存孔家时都会调用这个方法. 保证分配内存alloc时都相同*/
+(id)allocWithZone:(struct _NSZone *)zone{
    //调用dispatch_once保证在多线程中也只被实例化一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        systemAuth = [super allocWithZone:zone];
    });
    return systemAuth;
}

/**
 获取相机
 
 @return 是否授权
 */
- (BOOL)checkCameraAuthorization{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block BOOL isAuthorization = NO;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusNotDetermined || authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied)
    {
        isAuthorization = NO;
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            isAuthorization = granted;
            dispatch_semaphore_signal(semaphore);
        }];
    }
    else {
        isAuthorization = YES;
        dispatch_semaphore_signal(semaphore);
    }
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return isAuthorization;
}

/**
 获取语音授权
 
 @return 是否授权
 */
- (BOOL)checkAudioAuthrization {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block BOOL isAuthorization = YES;
    AVAuthorizationStatus audioAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (audioAuthStatus == AVAuthorizationStatusRestricted || audioAuthStatus == AVAuthorizationStatusNotDetermined || audioAuthStatus == AVAuthorizationStatusDenied)
    {
        isAuthorization = NO;
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            isAuthorization = granted;
            dispatch_semaphore_signal(semaphore);
        }];
    }
    else {
        isAuthorization = YES;
        dispatch_semaphore_signal(semaphore);
    }
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return isAuthorization;
}

/**
 获取访问相册权限
 
 @return 是否授权
 */
- (BOOL)checIMPhotoAlbumAuthorization {
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block BOOL isAuthorization = NO;
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusNotDetermined)
    {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status)
         {
             if (status == PHAuthorizationStatusAuthorized)
             {
                 // 授权成功或已授权
                 isAuthorization = YES;
                 dispatch_semaphore_signal(semaphore);
             }else{
                 isAuthorization = NO;
                 NSLog(@"Denied or Restricted");
                 //----为什么没有在这个里面进行权限判断，因为会项目会蹦。。。
                 dispatch_semaphore_signal(semaphore);
                 return;
             }
         }];
    }
    else if (status == PHAuthorizationStatusDenied)
    {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"权限选择" message:@"拍摄需要访问你的相册权限" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) { }];
        
        UIAlertAction *setting = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self requetSettingForAuth];
            });
        }];
        
        [alertController addAction:cancel];
        [alertController addAction:setting];
        UIViewController *currentVC = [UIViewController getCurrentVC];
        [currentVC presentViewController:alertController animated:YES completion:nil];
        isAuthorization = NO;
        dispatch_semaphore_signal(semaphore);
        //return;
    }
    else {
        isAuthorization = YES;
        dispatch_semaphore_signal(semaphore);
    }
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return isAuthorization;
}

/**
 跳转到设置页面
 */
- (void)requetSettingForAuth {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }
}
@end
