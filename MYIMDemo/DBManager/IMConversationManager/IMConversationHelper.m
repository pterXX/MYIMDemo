//
//  IMConversation.m
//  MYIMDemo
//
//  Created by admin on 2019/3/19.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "IMConversationHelper.h"
#import "IMDBConversationStore.h"

@interface IMConversationHelper()
@property (nonatomic, strong) IMDBConversationStore *conversationStore;
@end

@implementation IMConversationHelper

+ (IMConversationHelper *)sharedConversationHelper
{
    static IMConversationHelper *conversationHelper = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        conversationHelper = [[IMConversationHelper alloc] init];
    });
    return conversationHelper;
}

- (id)init
{
    if (self = [super init]) {
        // 初始化好友数据
        _conversationData = [self.conversationStore conversationsDataByUid:[IMUserHelper sharedHelper].userID];
    }
    return self;
}

#pragma mark - Public Methods -
- (IMConversationModel *)getConversationInfoByConversationId:(NSString *)conversationId
{
    if (conversationId == nil) {
        return nil;
    }
    for (IMConversationModel *model in self.conversationData) {
        if ([model.conversationId isEqualToString:conversationId]) {
            return model;
        }
    }
    return nil;
}

- (BOOL)deleteConversationByConversationId:(NSString *)conversationId
{
    BOOL ok = [self.conversationStore deleteConversationByFid:conversationId forUid:[IMUserHelper sharedHelper].userID];
    if (ok) {
        _conversationData = [self.conversationStore conversationsDataByUid:[IMUserHelper sharedHelper].userID];
        [IMNotificationCenter postNotificationName:kConversationDataChangedNot object:nil];
    }
    return ok;
}

- (BOOL)addConversation:(IMConversationModel *)conversation{
    if (conversation.conversationId.length == 0) {
        conversation.conversationId = [NSDate getCurrentTimestamp];
    }
   BOOL ok = [self.conversationStore addConversation:conversation forUid:[IMUserHelper sharedHelper].userID];
    if (ok) {
        _conversationData = [self.conversationStore conversationsDataByUid:[IMUserHelper sharedHelper].userID];
        [IMNotificationCenter postNotificationName:kConversationDataChangedNot object:nil];
    }
    return ok;
}

- (BOOL)updateConversationByConversationId:(IMConversationModel *)conversation{
    BOOL ok = [self.conversationStore addConversation:conversation forUid:[IMUserHelper sharedHelper].userID];
    if (ok) {
        _conversationData = [self.conversationStore conversationsDataByUid:[IMUserHelper sharedHelper].userID];
        [IMNotificationCenter postNotificationName:kConversationDataChangedNot object:nil];
    }
    return ok;
}


- (void)addDataChangedNotificationObserver:(id)observer usingBlock:(void(^)(NSArray * conversationData,NSInteger conversationCount))usingBlock{
    @weakify(self);
    [IMNotificationCenter addObserver:observer forName:kConversationDataChangedNot object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note, id  _Nonnull observer) {
        @strongify(self);
        if (usingBlock) {
            usingBlock(self.conversationData,self.conversationCount);
        }
    }];
}
#pragma mark - Getter
- (NSInteger)conversationCount
{
    return self.conversationData.count;
}

- (IMDBConversationStore *)conversationStore
{
    if (_conversationStore == nil) {
        _conversationStore = [[IMDBConversationStore alloc] init];
    }
    return _conversationStore;
}

@end
