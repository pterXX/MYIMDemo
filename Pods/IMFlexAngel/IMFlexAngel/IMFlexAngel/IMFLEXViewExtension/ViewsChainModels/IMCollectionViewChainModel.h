//
//  IMCollectionViewChainModel.h
//  zhuanzhuan
//
//  Created by 李伯坤 on 2017/10/24.
//  Copyright © 2017年 转转. All rights reserved.
//

#import "IMBaseViewChainModel.h"

@class IMCollectionViewChainModel;
@interface IMCollectionViewChainModel : IMBaseViewChainModel<IMCollectionViewChainModel *>

IMFLEX_CHAIN_PROPERTY IMCollectionViewChainModel *(^ collectionViewLayout)(UICollectionViewLayout *collectionViewLayout);
IMFLEX_CHAIN_PROPERTY IMCollectionViewChainModel *(^ delegate)(id<UICollectionViewDelegate> delegate);
IMFLEX_CHAIN_PROPERTY IMCollectionViewChainModel *(^ dataSource)(id<UICollectionViewDataSource> dataSource);

IMFLEX_CHAIN_PROPERTY IMCollectionViewChainModel *(^ allowsSelection)(BOOL allowsSelection);
IMFLEX_CHAIN_PROPERTY IMCollectionViewChainModel *(^ allowsMultipleSelection)(BOOL allowsMultipleSelection);

#pragma mark - UIScrollView
IMFLEX_CHAIN_PROPERTY IMCollectionViewChainModel *(^ contentSize)(CGSize contentSize);
IMFLEX_CHAIN_PROPERTY IMCollectionViewChainModel *(^ contentOffset)(CGPoint contentOffset);
IMFLEX_CHAIN_PROPERTY IMCollectionViewChainModel *(^ contentInset)(UIEdgeInsets contentInset);

IMFLEX_CHAIN_PROPERTY IMCollectionViewChainModel *(^ bounces)(BOOL bounces);
IMFLEX_CHAIN_PROPERTY IMCollectionViewChainModel *(^ alwaysBounceVertical)(BOOL alwaysBounceVertical);
IMFLEX_CHAIN_PROPERTY IMCollectionViewChainModel *(^ alwaysBounceHorizontal)(BOOL alwaysBounceHorizontal);

IMFLEX_CHAIN_PROPERTY IMCollectionViewChainModel *(^ pagingEnabled)(BOOL pagingEnabled);
IMFLEX_CHAIN_PROPERTY IMCollectionViewChainModel *(^ scrollEnabled)(BOOL scrollEnabled);

IMFLEX_CHAIN_PROPERTY IMCollectionViewChainModel *(^ showsHorizontalScrollIndicator)(BOOL showsHorizontalScrollIndicator);
IMFLEX_CHAIN_PROPERTY IMCollectionViewChainModel *(^ showsVerticalScrollIndicator)(BOOL showsVerticalScrollIndicator);

IMFLEX_CHAIN_PROPERTY IMCollectionViewChainModel *(^ scrollsToTop)(BOOL scrollsToTop);

@end

IMFLEX_EX_INTERFACE(UICollectionView, IMCollectionViewChainModel)
