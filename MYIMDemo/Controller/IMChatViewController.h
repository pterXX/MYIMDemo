//
//  IMChatViewController.h
//  MYIMDemo
//
//  Created by 徐世杰 on 2019/3/1.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "IMChatBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class IMConversationModel;
@interface IMChatViewController : IMChatBaseViewController
// 会话
@property (nonatomic, strong) IMConversationModel *conversation;
// 是否是从会话页面进入
@property (nonatomic, assign) BOOL               isConversationInto;
@end

NS_ASSUME_NONNULL_END
