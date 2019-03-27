//
//  IMExpressionDetailViewController.h
//  IMChat
//
//  Created by 李伯坤 on 16/4/8.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "IMBaseViewController.h"

@class IMExpressionGroupModel;
@interface IMExpressionDetailViewController : IMFlexibleLayoutViewController

@property (nonatomic, strong, readonly) IMExpressionGroupModel *groupModel;

- (id)initWithGroupModel:(IMExpressionGroupModel *)groupModel;

@end
