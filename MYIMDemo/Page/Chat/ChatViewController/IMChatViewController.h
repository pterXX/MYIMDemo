//
//  IMChatViewController.h
//  IMChat
//
//  Created by 李伯坤 on 16/2/15.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "IMChatBaseViewController.h"

@interface IMChatViewController : IMChatBaseViewController

- (instancetype)initWithUserId:(NSString *)userId;

- (instancetype)initWithGroupId:(NSString *)groupId;

@end
