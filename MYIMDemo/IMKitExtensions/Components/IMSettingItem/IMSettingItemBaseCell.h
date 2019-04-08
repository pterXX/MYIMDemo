//
//  IMSettingItemBaseCell.h
//  IMChat
//
//  Created by 徐世杰 on 2018/3/6.
//  Copyright © 2018年 徐世杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMSettingItem.h"

@interface IMSettingItemBaseCell : UICollectionViewCell <IMFlexibleLayoutViewProtocol>

/// 右箭头
@property (nonatomic, strong) UIImageView *arrowView;

@property (nonatomic, strong) IMSettingItem *item;

@end
