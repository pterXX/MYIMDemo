//
//  IMConversation+IMUser.m
//  IMChat
//
//  Created by 徐世杰 on 16/3/21.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "IMConversation+IMUser.h"

@implementation IMConversation (IMUser)

- (void)updateUserInfo:(IMUser *)user
{
    self.partnerName = user.showName;
    self.avatarPath = user.avatarPath;
    self.avatarURL = user.avatarURL;
}

- (void)updateGroupInfo:(IMGroup *)group
{
    self.partnerName = group.groupName;
    self.avatarPath = group.groupAvatarPath;
}

@end
