//
//  IMExpressionMoreCell.h
//  IMChat
//
//  Created by 徐世杰 on 2017/7/21.
//  Copyright © 2017年 徐世杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMExpressionGroupModel.h"

#define     WIDTH_EXPRESSION_MORE_CELL          MIN(((SCREEN_WIDTH - 15 * 4) / 3 - 1), 115)

@interface IMExpressionMoreCell : UICollectionViewCell <IMFlexibleLayoutViewProtocol>

@property (nonatomic, strong) IMExpressionGroupModel *groupModel;

@end
