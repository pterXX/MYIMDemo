//
//  IMConversation.h
//  MYIMDemo
//
//  Created by admin on 2019/3/19.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMConversationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface IMConversationHelper : NSObject
#pragma mark - # 好友

/// 对话数据(原始)
@property (nonatomic, strong, readonly) NSMutableArray *conversationData;


///  会话数量
@property (nonatomic, assign, readonly) NSInteger conversationCount;

+ (IMConversationHelper *)sharedConversationHelper;

- (IMConversationModel *)getConversationInfoByConversationId:(NSString *)conversationId;

- (BOOL)deleteConversationByConversationId:(NSString *)conversationId;

- (BOOL)addConversation:(IMConversationModel *)conversation;

- (BOOL)updateConversationByConversationId:(IMConversationModel *)conversation;

- (void)addDataChangedNotificationObserver:(id)observer usingBlock:(void(^)(NSArray * conversationData,NSInteger conversationCount))usingBlock;
@end

NS_ASSUME_NONNULL_END
