//
//  IMFlexibleLayoutViewController+Kernel.h
//  zhuanzhuan
//
//  Created by 李伯坤 on 2017/8/15.
//  Copyright © 2017年 转转. All rights reserved.
//

#import "IMFlexibleLayoutViewController.h"
#import "IMFlexibleLayoutFlowLayout.h"
#import "IMFlexibleLayoutViewModel.h"
#import "IMFlexibleLayoutSectionModel.h"

#define     CELL_SEPEARTOR          @"IMFlexibleLayoutSeperatorCell"

void RegisterCollectionViewCell(UICollectionView *collectionView, NSString *cellName);
void RegisterCollectionViewReusableView(UICollectionView *collectionView, NSString *kind, NSString *viewName);

@class IMFlexibleLayoutSectionModel;
@interface IMFlexibleLayoutViewController (Kernel) <
UICollectionViewDataSource,
UICollectionViewDelegate,
IMFlexibleLayoutFlowLayoutDelegate
>

- (IMFlexibleLayoutSectionModel *)sectionModelAtIndex:(NSInteger)section;

/// 根据tag获取sectionModel
- (IMFlexibleLayoutSectionModel *)sectionModelForTag:(NSInteger)sectionTag;

- (IMFlexibleLayoutViewModel *)viewModelAtIndexPath:(NSIndexPath *)indexPath;

- (NSArray<IMFlexibleLayoutViewModel *> *)viewModelsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

@end
