//
//  IMExpressionDetailItemCell.h
//  IMChat
//
//  Created by 徐世杰 on 16/4/8.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMExpressionModel.h"

#define         EXP_DETAIL_EDGE                 20.0
#define         EXP_DETAIL_SPACE                15.0
#define         EXP_DETAIL_CELL_WIDTH           MIN(((SCREEN_WIDTH - EXP_DETAIL_EDGE * 2 - EXP_DETAIL_SPACE * 3.0) / 4.0), 84)

@interface IMExpressionDetailItemCell : UICollectionViewCell <IMFlexibleLayoutViewProtocol>

@property (nonatomic, strong) IMExpressionModel *emoji;

@end
