//
//  IMSystemAuthorization.h
//  MYIMDemo
//
//  Created by 徐世杰 on 2019/3/1.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSystemAuthorization : NSObject
// 单例实例
+ (instancetype)shareInstance;

/**
 获取相机权限
 
 @return 是否授权
 */
- (BOOL)checkCameraAuthorization;

/**
 获取语音权限
 
 @return 是否授权
 */
- (BOOL)checkAudioAuthrization;

/**
 获取访问相册权限
 
 @return 是否授权
 */
- (BOOL)checIMPhotoAlbumAuthorization;

/**
 跳转到设置页面
 */
- (void)requetSettingForAuth;
@end

NS_ASSUME_NONNULL_END
