//
//  IMChatTextTableViewCell.h
//  KXiniuCloud
//
//  Created by eims on 2018/4/25.
//  Copyright © 2018年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IMChatTableViewCell.h"

@class IMTextView;

@interface IMChatTextTableViewCell : IMChatTableViewCell

// 消息文本框
@property (nonatomic, strong) IMTextView *textView;

@end
