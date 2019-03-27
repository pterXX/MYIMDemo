//
//  IMScrollViewChainModel.h
//  zhuanzhuan
//
//  Created by 李伯坤 on 2017/10/24.
//  Copyright © 2017年 转转. All rights reserved.
//

#import "IMBaseViewChainModel.h"

@class IMScrollViewChainModel;
@interface IMScrollViewChainModel : IMBaseViewChainModel<IMScrollViewChainModel *>

IMFLEX_CHAIN_PROPERTY IMScrollViewChainModel *(^ delegate)(id<UIScrollViewDelegate> delegate);

IMFLEX_CHAIN_PROPERTY IMScrollViewChainModel *(^ contentSize)(CGSize contentSize);
IMFLEX_CHAIN_PROPERTY IMScrollViewChainModel *(^ contentOffset)(CGPoint contentOffset);
IMFLEX_CHAIN_PROPERTY IMScrollViewChainModel *(^ contentInset)(UIEdgeInsets contentInset);

IMFLEX_CHAIN_PROPERTY IMScrollViewChainModel *(^ bounces)(BOOL bounces);
IMFLEX_CHAIN_PROPERTY IMScrollViewChainModel *(^ alwaysBounceVertical)(BOOL alwaysBounceVertical);
IMFLEX_CHAIN_PROPERTY IMScrollViewChainModel *(^ alwaysBounceHorizontal)(BOOL alwaysBounceHorizontal);

IMFLEX_CHAIN_PROPERTY IMScrollViewChainModel *(^ pagingEnabled)(BOOL pagingEnabled);
IMFLEX_CHAIN_PROPERTY IMScrollViewChainModel *(^ scrollEnabled)(BOOL scrollEnabled);

IMFLEX_CHAIN_PROPERTY IMScrollViewChainModel *(^ showsHorizontalScrollIndicator)(BOOL showsHorizontalScrollIndicator);
IMFLEX_CHAIN_PROPERTY IMScrollViewChainModel *(^ showsVerticalScrollIndicator)(BOOL showsVerticalScrollIndicator);

IMFLEX_CHAIN_PROPERTY IMScrollViewChainModel *(^ scrollsToTop)(BOOL scrollsToTop);

@end

IMFLEX_EX_INTERFACE(UIScrollView, IMScrollViewChainModel)
