//
//  IMChatUserProtocol.h
//  IMChat
//
//  Created by 徐世杰 on 16/5/6.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, IMChatUserType) {
    IMChatUserTypeUser = 0,
    IMChatUserTypeGroup,
};


@protocol IMChatUserProtocol <NSObject>

@property (nonatomic, strong, readonly) NSString *chat_userID;

@property (nonatomic, strong, readonly) NSString *chat_username;

@property (nonatomic, strong, readonly) NSString *chat_avatarURL;

@property (nonatomic, strong, readonly) NSString *chat_avatarPath;

@property (nonatomic, assign, readonly) NSInteger chat_userType;

@optional;
- (id)groupMemberByID:(NSString *)userID;

- (NSArray *)groupMembers;

@end
