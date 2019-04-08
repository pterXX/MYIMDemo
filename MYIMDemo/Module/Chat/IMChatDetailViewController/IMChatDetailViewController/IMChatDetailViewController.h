//
//  IMChatDetailViewController.h
//  IMChat
//
//  Created by 徐世杰 on 16/3/6.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMUser.h"

@interface IMChatDetailViewController : IMFlexibleLayoutViewController

@property (nonatomic, strong, readonly) IMUser *user;

- (instancetype)initWithUserModel:(IMUser *)user;
- (instancetype)init NS_UNAVAILABLE;

@end
