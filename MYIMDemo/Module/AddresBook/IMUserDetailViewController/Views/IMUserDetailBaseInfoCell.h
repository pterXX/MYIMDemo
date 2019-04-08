//
//  IMUserDetailBaseInfoCell.h
//  IMChat
//
//  Created by 徐世杰 on 16/2/29.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMUser.h"

@interface IMUserDetailBaseInfoCell : UICollectionViewCell <IMFlexibleLayoutViewProtocol>

@property (nonatomic, strong) IMUser *userModel;

@end
