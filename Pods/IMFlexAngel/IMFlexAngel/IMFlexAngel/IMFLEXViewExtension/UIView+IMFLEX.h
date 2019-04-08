//
//  UIView+IMFLEX.h
//  zhuanzhuan
//
//  Created by 李伯坤 on 2017/10/24.
//  Copyright © 2017年 转转. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+IMSeparator.h"

#import "IMViewChainModel.h"
#import "IMLabelChainModel.h"
#import "IMImageViewChainModel.h"

#import "IMControlChainModel.h"
#import "IMTextFieldChainModel.h"
#import "IMButtonChainModel.h"
#import "IMSwitchChainModel.h"

#import "IMScrollViewChainModel.h"
#import "IMTextViewChainModel.h"
#import "IMTableViewChainModel.h"
#import "IMCollectionViewChainModel.h"

#define     IMFLEX_VIEW_CHAIN_TYPE              @property (nonatomic, copy, readonly)

@interface UIView (IMFLEX)

/// 添加View
IMFLEX_VIEW_CHAIN_TYPE IMViewChainModel *(^ addView)(NSInteger tag);

/// 添加Label
IMFLEX_VIEW_CHAIN_TYPE IMLabelChainModel *(^ addLabel)(NSInteger tag);

/// 添加ImageView
IMFLEX_VIEW_CHAIN_TYPE IMImageViewChainModel *(^ addImageView)(NSInteger tag);

#pragma mark - # 按钮类
/// 添加Control
IMFLEX_VIEW_CHAIN_TYPE IMControlChainModel *(^ addControl)(NSInteger tag);

/// 添加TextField
IMFLEX_VIEW_CHAIN_TYPE IMTextFieldChainModel *(^ addTextField)(NSInteger tag);

/// 添加Button
IMFLEX_VIEW_CHAIN_TYPE IMButtonChainModel *(^ addButton)(NSInteger tag);

/// 添加Switch
IMFLEX_VIEW_CHAIN_TYPE IMSwitchChainModel *(^ addSwitch)(NSInteger tag);

#pragma mark - # 滚动视图类
/// 添加ScrollView
IMFLEX_VIEW_CHAIN_TYPE IMScrollViewChainModel *(^ addScrollView)(NSInteger tag);

/// 添加TextView
IMFLEX_VIEW_CHAIN_TYPE IMTextViewChainModel *(^ addTextView)(NSInteger tag);

/// 添加TableView
IMFLEX_VIEW_CHAIN_TYPE IMTableViewChainModel *(^ addTableView)(NSInteger tag);

/// 添加CollectionView
IMFLEX_VIEW_CHAIN_TYPE IMCollectionViewChainModel *(^ addCollectionView)(NSInteger tag);

@end
