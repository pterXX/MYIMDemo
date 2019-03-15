//
//  IMFlexibleLayoutSeperatorCell.h
//  IMFlexibleLayoutFrameworkDemo
//
//  Created by 李伯坤 on 2016/12/27.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMFlexibleLayoutViewProtocol.h"

#pragma mark - # IMFlexibleLayoutSeperatorModel
@interface IMFlexibleLayoutSeperatorModel : NSObject

@property (nonatomic, assign) CGSize size;

@property (nonatomic, strong) UIColor *color;

- (id)initWithSize:(CGSize)size andColor:(UIColor *)color;

@end


#pragma mark - # IMFlexibleLayoutSeperatorCell
@interface IMFlexibleLayoutSeperatorCell : UICollectionViewCell <IMFlexibleLayoutViewProtocol>

@property (nonatomic, strong) IMFlexibleLayoutSeperatorModel *model;

@end
