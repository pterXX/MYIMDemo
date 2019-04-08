//
//  IMCollectionViewChainModel.m
//  zhuanzhuan
//
//  Created by 李伯坤 on 2017/10/24.
//  Copyright © 2017年 转转. All rights reserved.
//

#import "IMCollectionViewChainModel.h"

#define     IMFLEX_CHAIN_COLLECTIONVIEW_IMPLEMENTATION(methodName, IMParamType)      IMFLEX_CHAIN_IMPLEMENTATION(methodName, IMParamType, IMCollectionViewChainModel *, UICollectionView)
#define     IMFLEX_CHAIN_SCROLLVIEW_IMPLEMENTATION(methodName, IMParamType)      IMFLEX_CHAIN_IMPLEMENTATION(methodName, IMParamType, IMCollectionViewChainModel *, UICollectionView)

@implementation IMCollectionViewChainModel

IMFLEX_CHAIN_COLLECTIONVIEW_IMPLEMENTATION(collectionViewLayout, UICollectionViewLayout *)
IMFLEX_CHAIN_COLLECTIONVIEW_IMPLEMENTATION(delegate, id<UICollectionViewDelegate>)
IMFLEX_CHAIN_COLLECTIONVIEW_IMPLEMENTATION(dataSource, id<UICollectionViewDataSource>)

IMFLEX_CHAIN_COLLECTIONVIEW_IMPLEMENTATION(allowsSelection, BOOL)
IMFLEX_CHAIN_COLLECTIONVIEW_IMPLEMENTATION(allowsMultipleSelection, BOOL)

#pragma mark - UIScrollView
IMFLEX_CHAIN_SCROLLVIEW_IMPLEMENTATION(contentSize, CGSize)
IMFLEX_CHAIN_SCROLLVIEW_IMPLEMENTATION(contentOffset, CGPoint)
IMFLEX_CHAIN_SCROLLVIEW_IMPLEMENTATION(contentInset, UIEdgeInsets)

IMFLEX_CHAIN_SCROLLVIEW_IMPLEMENTATION(bounces, BOOL)
IMFLEX_CHAIN_SCROLLVIEW_IMPLEMENTATION(alwaysBounceVertical, BOOL)
IMFLEX_CHAIN_SCROLLVIEW_IMPLEMENTATION(alwaysBounceHorizontal, BOOL)

IMFLEX_CHAIN_SCROLLVIEW_IMPLEMENTATION(pagingEnabled, BOOL)
IMFLEX_CHAIN_SCROLLVIEW_IMPLEMENTATION(scrollEnabled, BOOL)

IMFLEX_CHAIN_SCROLLVIEW_IMPLEMENTATION(showsHorizontalScrollIndicator, BOOL)
IMFLEX_CHAIN_SCROLLVIEW_IMPLEMENTATION(showsVerticalScrollIndicator, BOOL)

IMFLEX_CHAIN_SCROLLVIEW_IMPLEMENTATION(scrollsToTop, BOOL)

@end

IMFLEX_EX_IMPLEMENTATION(UICollectionView, IMCollectionViewChainModel)
