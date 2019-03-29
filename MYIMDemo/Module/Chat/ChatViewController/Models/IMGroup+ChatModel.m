
//
//  IMGroup+ChatModel.m
//  IMChat
//
//  Created by 徐世杰 on 16/5/6.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "IMGroup+ChatModel.h"

@implementation IMGroup (ChatModel)

- (NSString *)chat_userID
{
    return self.groupID;
}

- (NSString *)chat_username
{
    return self.groupName;
}

- (NSString *)chat_avatarURL
{
    return nil;
}

- (NSString *)chat_avatarPath
{
    return self.groupAvatarPath;
}

- (NSInteger)chat_userType
{
    return IMChatUserTypeGroup;
}

- (id)groupMemberByID:(NSString *)userID
{
    return [self memberByUserID:userID];
}

- (NSArray *)groupMembers
{
    return self.users;
}

@end
