//
//  IMCollectionViewChainModel.h
//  zhuanzhuan
//
//  Created by 李伯坤 on 2017/10/24.
//  Copyright © 2017年 转转. All rights reserved.
//

#import "IMBaseViewChainModel.h"

@class IMTableViewChainModel;
@interface IMTableViewChainModel : IMBaseViewChainModel<IMTableViewChainModel *>

IMFLEX_CHAIN_PROPERTY IMTableViewChainModel *(^ delegate)(id<UITableViewDelegate> delegate);
IMFLEX_CHAIN_PROPERTY IMTableViewChainModel *(^ dataSource)(id<UITableViewDataSource> dataSource);

IMFLEX_CHAIN_PROPERTY IMTableViewChainModel *(^ rowHeight)(CGFloat rowHeight);
IMFLEX_CHAIN_PROPERTY IMTableViewChainModel *(^ sectionHeaderHeight)(CGFloat sectionHeaderHeight);
IMFLEX_CHAIN_PROPERTY IMTableViewChainModel *(^ sectionFooterHeight)(CGFloat sectionFooterHeight);
IMFLEX_CHAIN_PROPERTY IMTableViewChainModel *(^ estimatedRowHeight)(CGFloat estimatedRowHeight);
IMFLEX_CHAIN_PROPERTY IMTableViewChainModel *(^ estimatedSectionHeaderHeight)(CGFloat estimatedSectionHeaderHeight);
IMFLEX_CHAIN_PROPERTY IMTableViewChainModel *(^ estimatedSectionFooterHeight)(CGFloat estimatedSectionFooterHeight);
IMFLEX_CHAIN_PROPERTY IMTableViewChainModel *(^ separatorInset)(UIEdgeInsets separatorInset);

IMFLEX_CHAIN_PROPERTY IMTableViewChainModel *(^ editing)(BOOL editing);
IMFLEX_CHAIN_PROPERTY IMTableViewChainModel *(^ allowsSelection)(BOOL allowsSelection);
IMFLEX_CHAIN_PROPERTY IMTableViewChainModel *(^ allowsMultipleSelection)(BOOL allowsMultipleSelection);
IMFLEX_CHAIN_PROPERTY IMTableViewChainModel *(^ allowsSelectionDuringEditing)(BOOL allowsSelectionDuringEditing);
IMFLEX_CHAIN_PROPERTY IMTableViewChainModel *(^ allowsMultipleSelectionDuringEditing)(BOOL allowsMultipleSelectionDuringEditing);

IMFLEX_CHAIN_PROPERTY IMTableViewChainModel *(^ separatorStyle)(UITableViewCellSeparatorStyle separatorStyle);
IMFLEX_CHAIN_PROPERTY IMTableViewChainModel *(^ separatorColor)(UIColor *separatorColor);

IMFLEX_CHAIN_PROPERTY IMTableViewChainModel *(^ tableHeaderView)(UIView * tableHeaderView);
IMFLEX_CHAIN_PROPERTY IMTableViewChainModel *(^ tableFooterView)(UIView * separatorStyle);

IMFLEX_CHAIN_PROPERTY IMTableViewChainModel *(^ sectionIndexBackgroundColor)(UIColor *sectionIndexBackgroundColor);
IMFLEX_CHAIN_PROPERTY IMTableViewChainModel *(^ sectionIndexColor)(UIColor *sectionIndexColor);

#pragma mark - UIScrollView
IMFLEX_CHAIN_PROPERTY IMTableViewChainModel *(^ contentSize)(CGSize contentSize);
IMFLEX_CHAIN_PROPERTY IMTableViewChainModel *(^ contentOffset)(CGPoint contentOffset);
IMFLEX_CHAIN_PROPERTY IMTableViewChainModel *(^ contentInset)(UIEdgeInsets contentInset);

IMFLEX_CHAIN_PROPERTY IMTableViewChainModel *(^ bounces)(BOOL bounces);
IMFLEX_CHAIN_PROPERTY IMTableViewChainModel *(^ alwaysBounceVertical)(BOOL alwaysBounceVertical);
IMFLEX_CHAIN_PROPERTY IMTableViewChainModel *(^ alwaysBounceHorizontal)(BOOL alwaysBounceHorizontal);

IMFLEX_CHAIN_PROPERTY IMTableViewChainModel *(^ pagingEnabled)(BOOL pagingEnabled);
IMFLEX_CHAIN_PROPERTY IMTableViewChainModel *(^ scrollEnabled)(BOOL scrollEnabled);

IMFLEX_CHAIN_PROPERTY IMTableViewChainModel *(^ showsHorizontalScrollIndicator)(BOOL showsHorizontalScrollIndicator);
IMFLEX_CHAIN_PROPERTY IMTableViewChainModel *(^ showsVerticalScrollIndicator)(BOOL showsVerticalScrollIndicator);

IMFLEX_CHAIN_PROPERTY IMTableViewChainModel *(^ scrollsToTop)(BOOL scrollsToTop);

@end

IMFLEX_EX_INTERFACE(UITableView, IMTableViewChainModel)
