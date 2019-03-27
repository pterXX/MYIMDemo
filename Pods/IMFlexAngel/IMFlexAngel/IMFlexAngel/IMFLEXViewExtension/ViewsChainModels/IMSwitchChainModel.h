//
//  IMSwitchChainModel.h
//  zhuanzhuan
//
//  Created by 李伯坤 on 2017/10/24.
//  Copyright © 2017年 转转. All rights reserved.
//

#import "IMBaseViewChainModel.h"

@class IMSwitchChainModel;
@interface IMSwitchChainModel : IMBaseViewChainModel<IMSwitchChainModel *>

IMFLEX_CHAIN_PROPERTY IMSwitchChainModel *(^ on)(BOOL on);
IMFLEX_CHAIN_PROPERTY IMSwitchChainModel *(^ onTintColor)(UIColor *onTintColor);
IMFLEX_CHAIN_PROPERTY IMSwitchChainModel *(^ thumbTintColor)(UIColor *thumbTintColor);

IMFLEX_CHAIN_PROPERTY IMSwitchChainModel *(^ onImage)(UIImage *onImage);
IMFLEX_CHAIN_PROPERTY IMSwitchChainModel *(^ offImage)(UIImage *offImage);

#pragma mark - # UIControl
IMFLEX_CHAIN_PROPERTY IMSwitchChainModel *(^ enabled)(BOOL enabled);
IMFLEX_CHAIN_PROPERTY IMSwitchChainModel *(^ selected)(BOOL selected);
IMFLEX_CHAIN_PROPERTY IMSwitchChainModel *(^ highlighted)(BOOL highlighted);

IMFLEX_CHAIN_PROPERTY IMSwitchChainModel *(^ eventBlock)(UIControlEvents controlEvents, void (^eventBlock)(id sender));

@end

IMFLEX_EX_INTERFACE(UISwitch, IMSwitchChainModel)
