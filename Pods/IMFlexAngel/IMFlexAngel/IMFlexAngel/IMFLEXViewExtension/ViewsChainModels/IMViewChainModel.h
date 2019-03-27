//
//  IMViewChainModel.h
//  IMFlexibleLayoutFramework
//
//  Created by 李伯坤 on 2017/11/12.
//  Copyright © 2017年 李伯坤. All rights reserved.
//

#import "IMBaseViewChainModel.h"

@class IMViewChainModel;
@interface IMViewChainModel : IMBaseViewChainModel <IMViewChainModel *>

@end

IMFLEX_EX_INTERFACE(UIView, IMViewChainModel)
