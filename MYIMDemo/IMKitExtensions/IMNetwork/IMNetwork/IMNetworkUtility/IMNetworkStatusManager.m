//
//  IMNetworkStatusManager.m
//  IMChat
//
//  Created by 李伯坤 on 2017/7/17.
//  Copyright © 2017年 李伯坤. All rights reserved.
//

#import "IMNetworkStatusManager.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

@interface IMNetworkStatusManager ()

@property (nonatomic, strong) AFNetworkReachabilityManager *manager;

@end

@implementation IMNetworkStatusManager
@synthesize networkStatus = _networkStatus;

+ (IMNetworkStatusManager *)sharedInstance
{
    static IMNetworkStatusManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[IMNetworkStatusManager alloc] init];
    });
    return manager;
}

- (id)init
{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStatusChanged:) name:CTRadioAccessTechnologyDidChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - # Public Methods
- (void)startNetworkStatusMonitoring
{
    [self.manager startMonitoring];
}

- (void)stopNetworkStatusMonitoring
{
    [self.manager stopMonitoring];
}

- (void)setNetworkChangedBlock:(void (^)(IMNetworkStatus))networkChangedBlock
{
    _networkChangedBlock = networkChangedBlock;
    @weakify(self);
    [self.manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        @strongify(self);
        if (self.networkChangedBlock) {
            switch (status) {
                case AFNetworkReachabilityStatusNotReachable:
                    self.networkStatus = IMNetworkStatusNone;
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    self.networkStatus = IMNetworkStatusWIFI;
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    self.networkStatus = IMNetworkStatusWWAN;
                    break;
                default:
                    self.networkStatus = IMNetworkStatusUnknown;
                    break;
            }
            self.networkChangedBlock(self.networkStatus);
        }
    }];
}

- (void)setNetworkStatus:(IMNetworkStatus)networkStatus
{
    _networkStatus = networkStatus;
}

#pragma mark - # Event Response
- (void)networkStatusChanged:(NSNotification *)notification
{
    if (notification && notification.name && [notification.name isEqualToString:CTRadioAccessTechnologyDidChangeNotification]) {
        NSString *netInfo = notification.object;
        if ([netInfo isEqualToString:CTRadioAccessTechnologyGPRS]) {
            _networkDetailType = IMNetworkDetailTypeGPRS;
        }
        else if ([netInfo isEqualToString:CTRadioAccessTechnologyEdge]) {
            _networkDetailType = IMNetworkDetailTypeEDGE;
        }
        else if ([netInfo isEqualToString:CTRadioAccessTechnologyWCDMA]) {
            _networkDetailType = IMNetworkDetailTypeUMTS;
        }
        else if ([netInfo isEqualToString:CTRadioAccessTechnologyHSDPA]) {
            _networkDetailType = IMNetworkDetailTypeHSDPA;
        }
        else if ([netInfo isEqualToString:CTRadioAccessTechnologyHSUPA]) {
            _networkDetailType = IMNetworkDetailTypeHSUPA;
        }
        else if ([netInfo isEqualToString:CTRadioAccessTechnologyCDMA1x]) {
            _networkDetailType = IMNetworkDetailTypeCDMA;
        }
        else if ([netInfo isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0]) {
            _networkDetailType = IMNetworkDetailTypeEVDO_0;
        }
        else if ([netInfo isEqualToString:CTRadioAccessTechnologyCDMAEVDORevA]) {
            _networkDetailType = IMNetworkDetailTypeEVDO_A;
        }
        else if ([netInfo isEqualToString:CTRadioAccessTechnologyCDMAEVDORevB]) {
            _networkDetailType = IMNetworkDetailTypeEVDO_B;
        }
        else if ([netInfo isEqualToString:CTRadioAccessTechnologyeHRPD]) {
            _networkDetailType = IMNetworkDetailTypeEHRPD;
        }
        else if ([netInfo isEqualToString:CTRadioAccessTechnologyLTE]) {
            _networkDetailType = IMNetworkDetailTypeLTE;
        }
        else {
            _networkDetailType = IMNetworkDetailTypeUNKNOWN;
        }
    }
}

#pragma mark - # Getters
- (AFNetworkReachabilityManager *)manager
{
    if (!_manager) {
        _manager = [AFNetworkReachabilityManager manager];
    }
    return _manager;
}

- (IMNetworkType)networkType
{
    if (self.networkStatus == IMNetworkStatusNone) {
        return IMNetworkTypeNone;
    }
    else if (self.networkStatus == IMNetworkStatusWIFI) {
        return IMNetworkTypeWIFI;
    }
    
    switch (self.networkDetailType) {
        case IMNetworkDetailTypeNOTREACHABLE:
            return IMNetworkTypeNone;
        case IMNetworkDetailTypeEDGE:
        case IMNetworkDetailTypeGPRS:
        case IMNetworkDetailTypeCDMA:
            return IMNetworkType2G;
        case IMNetworkDetailTypeHSDPA:
        case IMNetworkDetailTypeUMTS:
        case IMNetworkDetailTypeHSUPA:
        case IMNetworkDetailTypeEVDO_0:
        case IMNetworkDetailTypeEVDO_A:
        case IMNetworkDetailTypeEVDO_B:
        case IMNetworkDetailTypeEHRPD:
            return IMNetworkType3G;
        case IMNetworkDetailTypeLTE:
            return IMNetworkType4g;
        case IMNetworkDetailTypeWIFI:
            return IMNetworkTypeWIFI;
        default:
            break;
    }
    return IMNetworkTypeUnknown;
}

@end
