//
//  IMMyExpressionCell.h
//  IMChat
//
//  Created by 徐世杰 on 16/3/12.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "IMSettingItemBaseCell.h"
#import "IMExpressionGroupModel.h"

@protocol IMMyExpressionCellDelegate <NSObject>

- (void)myExpressionCellDeleteButtonDown:(IMExpressionGroupModel *)group;

@end

@interface IMMyExpressionCell : IMSettingItemBaseCell

@property (nonatomic, assign) id<IMMyExpressionCellDelegate>delegate;

@property (nonatomic, strong) IMExpressionGroupModel *group;

@end
