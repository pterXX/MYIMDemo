//
//  IMMoreKeyboardCell.h
//  IMChat
//
//  Created by 李伯坤 on 16/2/18.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMMoreKeyboardItem.h"

@interface IMMoreKeyboardCell : UICollectionViewCell

@property (nonatomic, strong) IMMoreKeyboardItem *item;

@property (nonatomic, strong) void(^clickBlock)(IMMoreKeyboardItem *item);

@end
