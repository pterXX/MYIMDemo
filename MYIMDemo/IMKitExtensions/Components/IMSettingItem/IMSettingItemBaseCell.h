//
//  IMSettingItemBaseCell.h
//  IMChat
//
//  Created by 李伯坤 on 2018/3/6.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMSettingItem.h"

@interface IMSettingItemBaseCell : UICollectionViewCell <IMFlexibleLayoutViewProtocol>

/// 右箭头
@property (nonatomic, strong) UIImageView *arrowView;

@property (nonatomic, strong) IMSettingItem *item;

@end
