//
//  IMUserDetailButtonCell.h
//  IMChat
//
//  Created by 徐世杰 on 2018/1/7.
//  Copyright © 2018年 徐世杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMFlexibleLayoutViewProtocol.h"
@interface IMUserDetailChatButtonCell : UICollectionViewCell <IMFlexibleLayoutViewProtocol>

@property (nonatomic, strong) UIButton *button;

@end
