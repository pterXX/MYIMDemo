//
//  IMSwitchChainModel.m
//  zhuanzhuan
//
//  Created by 李伯坤 on 2017/10/24.
//  Copyright © 2017年 转转. All rights reserved.
//

#import "IMSwitchChainModel.h"
#import "UIControl+IMEvent.h"

#define     IMFLEX_CHAIN_SWITCH_IMPLEMENTATION(methodName, IMParamType)      IMFLEX_CHAIN_IMPLEMENTATION(methodName, IMParamType, IMSwitchChainModel *, UISwitch)

@implementation IMSwitchChainModel

IMFLEX_CHAIN_SWITCH_IMPLEMENTATION(on, BOOL);
IMFLEX_CHAIN_SWITCH_IMPLEMENTATION(onTintColor, UIColor *);
IMFLEX_CHAIN_SWITCH_IMPLEMENTATION(thumbTintColor, UIColor *);

IMFLEX_CHAIN_SWITCH_IMPLEMENTATION(onImage, UIImage *);
IMFLEX_CHAIN_SWITCH_IMPLEMENTATION(offImage, UIImage *);

#pragma mark - # UIControl
IMFLEX_CHAIN_SWITCH_IMPLEMENTATION(enabled, BOOL);
IMFLEX_CHAIN_SWITCH_IMPLEMENTATION(selected, BOOL);
IMFLEX_CHAIN_SWITCH_IMPLEMENTATION(highlighted, BOOL);

- (IMSwitchChainModel *(^)(UIControlEvents controlEvents, void (^eventBlock)(id sender)))eventBlock
{
    return ^IMSwitchChainModel *(UIControlEvents controlEvents, void (^eventBlock)(id sender)) {
        [(UIControl *)self.view addControlEvents:controlEvents handler:eventBlock];
        return self;
    };
}

@end

IMFLEX_EX_IMPLEMENTATION(UISwitch, IMSwitchChainModel)
