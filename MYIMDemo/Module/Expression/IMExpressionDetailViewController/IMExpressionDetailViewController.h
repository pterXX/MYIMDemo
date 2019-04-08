//
//  IMExpressionDetailViewController.h
//  IMChat
//
//  Created by 徐世杰 on 16/4/8.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "IMBaseViewController.h"

@class IMExpressionGroupModel;
@interface IMExpressionDetailViewController : IMFlexibleLayoutViewController

@property (nonatomic, strong, readonly) IMExpressionGroupModel *groupModel;

- (id)initWithGroupModel:(IMExpressionGroupModel *)groupModel;

@end
