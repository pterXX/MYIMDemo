//
//  IMMacros.h
//  IMChat
//
//  Created by 徐世杰 on 2017/9/20.
//  Copyright © 2017年 徐世杰. All rights reserved.
//

#ifndef IMMacros_h
#define IMMacros_h


// 网络请求成功回调
typedef void(^IMBlockRequestSuccessWithDatas)(id datas);

@class NSString;
// 网络请求失败回调
typedef void(^IMBlockRequestFailureWithErrorMessage)(NSString *errMsg);


#define SCREEN_WIDTH (IMSCREEN_WIDTH)
#define SCREEN_HEIGHT (IMSCREEN_HEIGHT)

#pragma mark - # 调试相关宏
#define     DEBUG_LOCAL_SERVER      // 使用本地测试服务器
//#define     DEBUG_MEMERY            // 内存测试


#pragma mark - # 服务器地址
// 服务器
#define     HOST_URL                    @"http://101.200.134.35:8000/"
//#define     HOST_URL                    @"http://10.252.146.27:8000/"

// 表情服务器
#define     IEXPRESSION_HOST_URL        @"http://123.57.155.230/ibiaoqing/admin/"


#define mark - # Default
// 默认头像
#define     DEFAULT_AVATAR_PATH         @"default_head"

#endif /* IMMacros_h */
