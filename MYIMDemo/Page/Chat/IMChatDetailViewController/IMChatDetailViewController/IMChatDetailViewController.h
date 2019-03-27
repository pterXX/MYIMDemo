//
//  IMChatDetailViewController.h
//  IMChat
//
//  Created by 李伯坤 on 16/3/6.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMUser.h"

@interface IMChatDetailViewController : IMFlexibleLayoutViewController

@property (nonatomic, strong, readonly) IMUser *user;

- (instancetype)initWithUserModel:(IMUser *)user;
- (instancetype)init NS_UNAVAILABLE;

@end
