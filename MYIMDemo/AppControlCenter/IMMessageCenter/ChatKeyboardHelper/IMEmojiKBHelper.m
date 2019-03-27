//
//  IMEmojiKBHelper.m
//  IMChat
//
//  Created by 李伯坤 on 16/2/20.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "IMEmojiKBHelper.h"
#import "IMExpressionHelper.h"
#import "IMExpressionGroupModel.h"

static IMEmojiKBHelper *helper;

@interface IMEmojiKBHelper ()

@property (nonatomic, strong) NSString *userID;

@property (nonatomic, strong) IMExpressionGroupModel *systemEditGroup;

@property (nonatomic, strong) void (^complete)(NSMutableArray *);

@end

@implementation IMEmojiKBHelper

+ (IMEmojiKBHelper *)sharedKBHelper
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        helper = [[IMEmojiKBHelper alloc] init];
    });
    return helper;
}

- (void)updateEmojiGroupData
{
    if (self.userID && self.complete) {
        [self emojiGroupDataByUserID:self.userID complete:self.complete];
    }
}

- (void)emojiGroupDataByUserID:(NSString *)userID complete:(void (^)(NSMutableArray *))complete
{
    self.userID = userID;
    self.complete = complete;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableArray *emojiGroupData = [[NSMutableArray alloc] init];
        
        // 默认表情包
        [emojiGroupData addObject:[IMExpressionHelper sharedHelper].defaultFaceGroup];
        [emojiGroupData addObject:[IMExpressionHelper sharedHelper].defaultSystemEmojiGroup];
        
        // 用户收藏的表情包
        IMExpressionGroupModel *preferEmojiGroup = [IMExpressionHelper sharedHelper].userPreferEmojiGroup;
        if (preferEmojiGroup && preferEmojiGroup.count > 0) {
            [emojiGroupData addObject:preferEmojiGroup];
        }
        
        // 用户的表情包
        NSArray *userGroups = [IMExpressionHelper sharedHelper].userEmojiGroups;
        if (userGroups && userGroups.count > 0) {
            [emojiGroupData addObjectsFromArray:userGroups];
        }
        
        // 系统设置
        [emojiGroupData addObject:self.systemEditGroup];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            complete(emojiGroupData);
        });
    });
}

#pragma mark - # Getter
- (IMExpressionGroupModel *)systemEditGroup
{
    if (_systemEditGroup == nil) {
        _systemEditGroup = [[IMExpressionGroupModel alloc] init];
        _systemEditGroup.type = IMEmojiTypeOther;
        _systemEditGroup.iconPath = @"emojiKB_settingBtn";
    }
    return _systemEditGroup;
}


@end
