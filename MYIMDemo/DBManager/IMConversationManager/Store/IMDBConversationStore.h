//
//  IMConversationStore.h
//  MYIMDemo
//
//  Created by admin on 2019/3/19.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "IMDBBaseStore.h"

NS_ASSUME_NONNULL_BEGIN

@interface IMDBConversationStore : IMDBBaseStore
- (BOOL)addConversation:(IMConversationModel *)conversation forUid:(NSString *)uid;

- (BOOL)updateConversationsData:(NSArray *)conversationData forUid:(NSString *)uid;

- (NSMutableArray *)conversationsDataByUid:(NSString *)uid;

- (BOOL)deleteConversationByFid:(NSString *)fid forUid:(NSString *)uid;
@end

NS_ASSUME_NONNULL_END
