//
//  IMConversation+IMUser.h
//  IMChat
//
//  Created by 徐世杰 on 16/3/21.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "IMConversation.h"
#import "IMUser+ChatModel.h"
#import "IMGroup+ChatModel.h"

@interface IMConversation (IMUser)

- (void)updateUserInfo:(IMUser *)user;

- (void)updateGroupInfo:(IMGroup *)group;

@end
