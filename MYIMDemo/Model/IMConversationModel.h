//
//  IMConversationModel.h
//  MYIMDemo
//
//  Created by 徐世杰 on 2019/3/1.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMBaseModel.h"
#import "IMMessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface IMConversationModel : IMBaseModel
// 会话名
@property (nonatomic, strong) NSString            *conversationName;
// 会话id
@property (nonatomic, strong) NSString            *conversationId;
// 会话类型
@property (nonatomic, assign) IMMessageChatType    chatType;
// 会话头像
@property (nonatomic, strong) NSString            *headImage;
// 最后一条消息
@property (nonatomic, strong) IMMessageModel       *message;
// 未读消息
@property (nonatomic, assign) int                 badgeNumber;
// 犀牛id
@property (nonatomic, strong) NSString            *toUserId;
// 员工id
@property (nonatomic, strong) NSString            *toEmployeeId;
@end

NS_ASSUME_NONNULL_END
