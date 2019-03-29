//
//  IMUserGroupItemCell.h
//  IMChat
//
//  Created by 徐世杰 on 16/3/6.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IMUser;
@interface IMUserGroupItemCell : UICollectionViewCell

@property (nonatomic, strong) IMUser *user;

@property (nonatomic, strong) void (^clickBlock)(IMUser *user);

@end
