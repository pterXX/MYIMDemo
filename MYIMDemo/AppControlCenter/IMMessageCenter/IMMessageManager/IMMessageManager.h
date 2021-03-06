//
//  IMMessageManager.h
//  IMChat
//
//  Created by 徐世杰 on 16/3/13.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "IMDBConversationStore.h"
#import "IMDBMessageStore.h"
#import "IMMessage.h"
#import "IMMessageManagerChatVCDelegate.h"
#import "IMMessageManagerConvVCDelegate.h"
#import <Foundation/Foundation.h>

@interface IMMessageManager : NSObject

@property (nonatomic, assign) id<IMMessageManagerChatVCDelegate>messageDelegate;
@property (nonatomic, assign) id<IMMessageManagerConvVCDelegate>conversationDelegate;

@property (nonatomic, strong, readonly) NSString *userID;

@property (nonatomic, strong) IMDBMessageStore *messageStore;

@property (nonatomic, strong) IMDBConversationStore *conversationStore;

+ (IMMessageManager *)sharedInstance;

#pragma mark - 发送
- (void)sendMessage:(IMMessage *)message
           progress:(void (^)(IMMessage *, CGFloat))progress
            success:(void (^)(IMMessage *))success
            failure:(void (^)(IMMessage *))failure;

@end
