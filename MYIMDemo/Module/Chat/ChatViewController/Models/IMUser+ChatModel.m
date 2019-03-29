//
//  IMUser+ChatModel.m
//  IMChat
//
//  Created by 徐世杰 on 16/5/6.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "IMUser+ChatModel.h"

@implementation IMUser (ChatModel)

- (NSString *)chat_userID
{
    return self.userID;
}

- (NSString *)chat_username
{
    return self.showName;
}

- (NSString *)chat_avatarURL
{
    return self.avatarURL;
}

- (NSString *)chat_avatarPath
{
    return self.avatarPath;
}

- (NSInteger)chat_userType
{
    return IMChatUserTypeUser;
}

@end
