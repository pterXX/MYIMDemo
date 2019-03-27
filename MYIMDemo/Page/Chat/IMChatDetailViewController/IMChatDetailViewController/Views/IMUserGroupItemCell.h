//
//  IMUserGroupItemCell.h
//  IMChat
//
//  Created by 李伯坤 on 16/3/6.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IMUser;
@interface IMUserGroupItemCell : UICollectionViewCell

@property (nonatomic, strong) IMUser *user;

@property (nonatomic, strong) void (^clickBlock)(IMUser *user);

@end
