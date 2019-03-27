//
//  IMExpressionItemCell.h
//  IMChat
//
//  Created by 李伯坤 on 16/4/4.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IMExpressionGroupModel;
@interface IMExpressionItemCell : UITableViewCell <IMFlexibleLayoutViewProtocol>

@property (nonatomic, strong) IMExpressionGroupModel *groupModel;

@end
