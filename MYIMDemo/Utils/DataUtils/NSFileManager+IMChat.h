//
//  NSFileManager+TLChat.h
//  TLChat
//
//  Created by 徐世杰 on 16/3/3.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSFileManager (IMChat)
+ (NSURL *)documentsURL;
+ (NSString *)documentsPath;


+ (NSURL *)libraryURL;
+ (NSString *)libraryPath;


+ (NSURL *)cachesURL;
+ (NSString *)cachesPath;

+ (NSURL *)tempURL;
+ (NSString *)tempPath;

+ (BOOL)addSkipBackupAttributeToFile:(NSString *)path;

+ (double)availableDiskSpace;

/**
 *  图片 — 设置
 */
+ (NSString *)pathUserSettingImage:(NSString *)imageName;

/**
 *  图片临时文件地址
 */
+ (NSString *)pathTempSettingImage:(NSString *)imageName;

/**
 *  视频临时文件地址
 */
+ (NSString *)pathTempSettingVideo:(NSString *)video;

/**
 *  语音临时文件地址
 */
+ (NSString *)pathTempSettingVoice:(NSString *)voice;

/**
 *  图片 — 聊天
 */
+ (NSString *)pathUserChatImage:(NSString*)imageName;

/**
 *  图片 — 聊天背景
 */
+ (NSString *)pathUserChatBackgroundImage:(NSString *)imageName;

/**
 *  图片 — 用户头像
 */
+ (NSString *)pathUserAvatar:(NSString *)imageName;

/**
 *  图片 — 屏幕截图
 */
+ (NSString *)pathScreenshotImage:(NSString *)imageName;

/**
 *  图片 — 本地通讯录
 */
+ (NSString *)pathContactsAvatar:(NSString *)imageName;

/**
 *  聊天语音
 */
+ (NSString *)pathUserChatVoice:(NSString *)voiceName;

/**
 *  视频
 */
+ (NSString *)pathUserChatVideo:(NSString *)videoName;

/**
 *  表情
 */
+ (NSString *)pathExpressionForGroupID:(NSString *)groupID;

/**
 *  数据 — 本地通讯录
 */
+ (NSString *)pathContactsData;

/**
 *  数据库 — 通用
 */
+ (NSString *)pathDBCommon;

/**
 *  数据库 — 聊天
 */
+ (NSString *)pathDBMessage;

/**
 *  缓存
 */
+ (NSString *)cacheForFile:(NSString *)filename;


@end
