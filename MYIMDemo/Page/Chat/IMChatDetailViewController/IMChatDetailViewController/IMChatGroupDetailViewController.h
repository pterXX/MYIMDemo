//
//  IMChatGroupDetailViewController.h
//  IMChat
//
//  Created by 李伯坤 on 16/3/8.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMGroup.h"

@interface IMChatGroupDetailViewController : IMFlexibleLayoutViewController

@property (nonatomic, strong, readonly) IMGroup *group;

- (instancetype)initWithGroupModel:(IMGroup *)groupModel;
- (instancetype)init NS_UNAVAILABLE;

@end
