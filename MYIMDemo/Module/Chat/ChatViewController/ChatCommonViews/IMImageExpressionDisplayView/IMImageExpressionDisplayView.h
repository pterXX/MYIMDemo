//
//  IMImageExpressionDisplayView.h
//  IMChat
//
//  Created by 徐世杰 on 16/3/16.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMExpressionModel.h"

@interface IMImageExpressionDisplayView : UIView

@property (nonatomic, strong) IMExpressionModel *emoji;

@property (nonatomic, assign) CGRect rect;

- (void)displayEmoji:(IMExpressionModel *)emoji atRect:(CGRect)rect;

@end
