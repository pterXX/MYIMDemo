//
//  IMChatViewController.h
//  IMChat
//
//  Created by 徐世杰 on 16/2/15.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "IMChatBaseViewController.h"

@interface IMChatViewController : IMChatBaseViewController

- (instancetype)initWithUserId:(NSString *)userId;

- (instancetype)initWithGroupId:(NSString *)groupId;

@end
