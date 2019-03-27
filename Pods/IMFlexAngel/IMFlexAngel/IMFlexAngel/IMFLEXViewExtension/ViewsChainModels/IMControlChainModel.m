//
//  IMControlChainModel.m
//  zhuanzhuan
//
//  Created by 李伯坤 on 2017/10/24.
//  Copyright © 2017年 转转. All rights reserved.
//

#import "IMControlChainModel.h"
#import "UIControl+IMEvent.h"

#define     IMFLEX_CHAIN_CONTROL_IMPLEMENTATION(methodName, IMParamType)      IMFLEX_CHAIN_IMPLEMENTATION(methodName, IMParamType, IMControlChainModel *, UIControl)

@implementation IMControlChainModel

IMFLEX_CHAIN_CONTROL_IMPLEMENTATION(enabled, BOOL);
IMFLEX_CHAIN_CONTROL_IMPLEMENTATION(selected, BOOL);
IMFLEX_CHAIN_CONTROL_IMPLEMENTATION(highlighted, BOOL);

- (IMControlChainModel *(^)(UIControlEvents controlEvents, void (^eventBlock)(id sender)))eventBlock
{
    return ^IMControlChainModel *(UIControlEvents controlEvents, void (^eventBlock)(id sender)) {
        [(UIControl *)self.view addControlEvents:controlEvents handler:eventBlock];
        return self;
    };
}

IMFLEX_CHAIN_CONTROL_IMPLEMENTATION(contentVerticalAlignment, UIControlContentVerticalAlignment);
IMFLEX_CHAIN_CONTROL_IMPLEMENTATION(contentHorizontalAlignment, UIControlContentHorizontalAlignment);

@end

IMFLEX_EX_IMPLEMENTATION(UIControl, IMControlChainModel)
