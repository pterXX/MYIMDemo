//
//  IMChatImageTableViewCell.h
//  KXiniuCloud
//
//  Created by eims on 2018/5/11.
//  Copyright © 2018年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IMChatTableViewCell.h"


@interface IMChatImageTableViewCell : IMChatTableViewCell

// 图片
@property (nonatomic, strong) UIImageView *messageImageView;

// 图片点击事件
@property (nonatomic, strong) UITapGestureRecognizer *tapImageView;

@end
