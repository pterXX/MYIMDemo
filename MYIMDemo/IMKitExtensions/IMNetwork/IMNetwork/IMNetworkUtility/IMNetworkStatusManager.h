//
//  IMNetworkStatusManager.h
//  IMChat
//
//  Created by 李伯坤 on 2017/7/17.
//  Copyright © 2017年 李伯坤. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 网络状态
typedef NS_ENUM(NSInteger, IMNetworkStatus) {
    IMNetworkStatusUnknown          = -1,
    IMNetworkStatusNone             = 0,
    IMNetworkStatusWWAN             = 1,
    IMNetworkStatusWIFI             = 2,
};

/// 联网类型
typedef NS_ENUM(NSInteger, IMNetworkType) {
    IMNetworkTypeUnknown = -1,
    IMNetworkTypeNone    = 0,
    IMNetworkTypeWIFI    = 1,
    IMNetworkType2G      = 2,
    IMNetworkType3G      = 3,
    IMNetworkType4g      = 4,
};

/// 详细网络状态
typedef NS_ENUM(NSInteger, IMNetworkDetailType) {
    IMNetworkDetailTypeNOTREACHABLE = -1,
    IMNetworkDetailTypeUNKNOWN = 0,
    IMNetworkDetailTypeGPRS = 1,
    IMNetworkDetailTypeEDGE = 2,
    IMNetworkDetailTypeUMTS = 3,
    IMNetworkDetailTypeCDMA = 4,
    IMNetworkDetailTypeEVDO_0 = 5,
    IMNetworkDetailTypeEVDO_A = 6,
    IMNetworkDetailType1xRTT = 7,
    IMNetworkDetailTypeHSDPA = 8,
    IMNetworkDetailTypeHSUPA = 9,
    IMNetworkDetailTypeHSPA = 10,
    IMNetworkDetailTypeIDEN = 11,
    IMNetworkDetailTypeEVDO_B = 12,
    IMNetworkDetailTypeLTE = 13,
    IMNetworkDetailTypeEHRPD = 14,
    IMNetworkDetailTypeHSPAP = 15,
    IMNetworkDetailTypeGSM = 16,
    IMNetworkDetailTypeTD_SCDMA = 17,
    IMNetworkDetailTypeIWLAN = 18,
    IMNetworkDetailTypeWIFI = 99
};


@interface IMNetworkStatusManager : NSObject

/// 网络状态（Unkown, None, WWAN, WIFI）
@property (nonatomic, assign, readonly) IMNetworkStatus networkStatus;

/// 联网类型（None, Unknown, WIFI, 2/3/4G）
@property (nonatomic, assign, readonly) IMNetworkType networkType;

/// 详细网络状态
@property (nonatomic, assign, readonly) IMNetworkDetailType networkDetailType;


@property (nonatomic, copy) void (^networkChangedBlock)(IMNetworkStatus status);

+ (IMNetworkStatusManager *)sharedInstance;

/**
 * 开始网络状态监控
 */
- (void)startNetworkStatusMonitoring;

/**
 * 停止网络状态监控
 */
- (void)stopNetworkStatusMonitoring;

@end
