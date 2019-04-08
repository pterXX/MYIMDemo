//
//  IMControlChainModel.h
//  zhuanzhuan
//
//  Created by 李伯坤 on 2017/10/24.
//  Copyright © 2017年 转转. All rights reserved.
//

#import "IMBaseViewChainModel.h"

@class IMControlChainModel;
@interface IMControlChainModel : IMBaseViewChainModel<IMControlChainModel *>

IMFLEX_CHAIN_PROPERTY IMControlChainModel *(^ enabled)(BOOL enabled);
IMFLEX_CHAIN_PROPERTY IMControlChainModel *(^ selected)(BOOL selected);
IMFLEX_CHAIN_PROPERTY IMControlChainModel *(^ highlighted)(BOOL highlighted);

IMFLEX_CHAIN_PROPERTY IMControlChainModel *(^ eventBlock)(UIControlEvents controlEvents, void (^eventBlock)(id sender));

IMFLEX_CHAIN_PROPERTY IMControlChainModel *(^ contentVerticalAlignment)(UIControlContentVerticalAlignment contentVerticalAlignment);
IMFLEX_CHAIN_PROPERTY IMControlChainModel *(^ contentHorizontalAlignment)(UIControlContentHorizontalAlignment contentHorizontalAlignment);


@end

IMFLEX_EX_INTERFACE(UIControl, IMControlChainModel)
