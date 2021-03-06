//
//  IMExpressionDetailInfoCell.h
//  IMChat
//
//  Created by 徐世杰 on 16/4/11.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMExpressionGroupModel.h"

#define         HEIGHT_EXP_BANNER       (SCREEN_WIDTH * 0.45)

@interface IMExpressionDetailInfoCell : UICollectionViewCell <IMFlexibleLayoutViewProtocol>

@property (nonatomic, strong) IMExpressionGroupModel *groupModel;

@end
