//
//  IMImageViewChainModel.h
//  zhuanzhuan
//
//  Created by 李伯坤 on 2017/10/24.
//  Copyright © 2017年 转转. All rights reserved.
//

#import "IMBaseViewChainModel.h"

@class IMImageViewChainModel;
@interface IMImageViewChainModel : IMBaseViewChainModel <IMImageViewChainModel *>

IMFLEX_CHAIN_PROPERTY IMImageViewChainModel *(^ image)(UIImage *image);
IMFLEX_CHAIN_PROPERTY IMImageViewChainModel *(^ highlightedImage)(UIImage *highlightedImage);
IMFLEX_CHAIN_PROPERTY IMImageViewChainModel *(^ highlighted)(BOOL highlighted);

@end

IMFLEX_EX_INTERFACE(UIImageView, IMImageViewChainModel)
