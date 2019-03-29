//
//  IMExpressionHelper.m
//  IMChat
//
//  Created by 徐世杰 on 16/3/11.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "IMExpressionHelper.h"
#import "IMDBExpressionStore.h"
#import "IMEmojiKBHelper.h"
#import "IMUserHelper.h"
#import "NSFileManager+IMChat.h"

@interface IMExpressionHelper ()

@property (nonatomic, strong) IMDBExpressionStore *store;

@end

@implementation IMExpressionHelper
@synthesize defaultFaceGroup = _defaultFaceGroup;
@synthesize defaultSystemEmojiGroup = _defaultSystemEmojiGroup;
@synthesize userEmojiGroups = _userEmojiGroups;

+ (IMExpressionHelper *)sharedHelper
{
    static IMExpressionHelper *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[IMExpressionHelper alloc] init];
    });
    return helper;
}

- (NSArray *)userEmojiGroups
{
    return [self.store expressionGroupsByUid:[IMUserHelper sharedHelper].userID];
}

- (BOOL)addExpressionGroup:(IMExpressionGroupModel *)emojiGroup
{
    BOOL ok = [self.store addExpressionGroup:emojiGroup forUid:[IMUserHelper sharedHelper].userID];
    if (ok) {       // 通知表情键盘
        [[IMEmojiKBHelper sharedKBHelper] updateEmojiGroupData];
    }
    return ok;
}

- (BOOL)deleteExpressionGroupByID:(NSString *)groupID
{
    IMExpressionGroupModel *groupModel = [self emojiGroupByID:groupID];
    BOOL ok = [self.store deleteExpressionGroupByID:groupID forUid:[IMUserHelper sharedHelper].userID];
    if (ok) {       // 通知表情键盘
        [[IMEmojiKBHelper sharedKBHelper] updateEmojiGroupData];
        
        BOOL canDeleteFile = ![self didExpressionGroupAlwaysInUsed:groupID];
        if (canDeleteFile) {
            NSError *error;
            ok = [[NSFileManager defaultManager] removeItemAtPath:groupModel.path error:&error];
            if (!ok) {
                DDLogError(@"删除表情文件失败\n路径:%@\n原因:%@", groupModel.path, [error description]);
            }
        }
    }
    return ok;
}

- (BOOL)didExpressionGroupAlwaysInUsed:(NSString *)groupID
{
    NSInteger count = [self.store countOfUserWhoHasExpressionGroup:groupID];
    return count > 0;
}

- (IMExpressionGroupModel *)emojiGroupByID:(NSString *)groupID;
{
    for (IMExpressionGroupModel *group in self.userEmojiGroups) {
        if ([group.gId isEqualToString:groupID]) {
            return group;
        }
    }
    return nil;
}

- (void)downloadExpressionsWithGroupInfo:(IMExpressionGroupModel *)group
                                progress:(void (^)(CGFloat))progress
                                 success:(void (^)(IMExpressionGroupModel *))success
                                 failure:(void (^)(IMExpressionGroupModel *, NSString *))failure
{
    group.type = IMEmojiTypeImageWithTitle;
    dispatch_queue_t downloadQueue = dispatch_queue_create([group.gId UTF8String], nil);
    dispatch_group_t downloadGroup = dispatch_group_create();
    
    __block CGFloat p = 0;
    for (int i = 0; i <= group.data.count; i++) {
        dispatch_group_async(downloadGroup, downloadQueue, ^{
            NSString *groupPath = [NSFileManager pathExpressionForGroupID:group.gId];
            NSString *emojiPath;
            NSData *data = nil;
            if (i == group.data.count) {
                emojiPath = [NSString stringWithFormat:@"%@icon_%@", groupPath, group.gId];
                data = [NSData dataWithContentsOfURL:IMURL(group.iconURL)];
            }
            else {
                IMExpressionModel *emoji = group.data[i];
                NSString *urlString = [IMExpressionModel expressionDownloadURLWithEid:emoji.eId];
                data = [NSData dataWithContentsOfURL:IMURL(urlString)];
                if (data == nil) {
                    urlString = [IMExpressionModel expressionURLWithEid:emoji.eId];
                    data = [NSData dataWithContentsOfURL:IMURL(urlString)];
                }
                emojiPath = [NSString stringWithFormat:@"%@%@", groupPath, emoji.eId];
            }
            
            [data writeToFile:emojiPath atomically:YES];
            p += 1.0;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (progress) {
                    progress(p / group.data.count);
                }
            });
        });
    }
    dispatch_group_notify(downloadGroup, dispatch_get_main_queue(), ^{
        success(group);
    });
}

- (void)updateExpressionGroupModelsStatus:(NSArray *)groupModelArray
{
    for (IMExpressionGroupModel *group in groupModelArray) {
        IMExpressionGroupModel *localEmojiGroup = [[IMExpressionHelper sharedHelper] emojiGroupByID:group.gId];
        if (localEmojiGroup) {
            group.status = IMExpressionGroupStatusLocal;
        }
    }
}

#pragma mark - # Getter
- (IMDBExpressionStore *)store
{
    if (_store == nil) {
        _store = [[IMDBExpressionStore alloc] init];
    }
    return _store;
}

- (IMExpressionGroupModel *)defaultFaceGroup
{
    if (_defaultFaceGroup == nil) {
        _defaultFaceGroup = [[IMExpressionGroupModel alloc] init];
        _defaultFaceGroup.type = IMEmojiTypeFace;
        _defaultFaceGroup.iconPath = @"emojiKB_group_face";
        NSString *path = [[NSBundle mainBundle] pathForResource:@"FaceEmoji" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        _defaultFaceGroup.data = [IMExpressionModel mj_objectArrayWithKeyValuesArray:data];
        for (IMExpressionModel *emoji in _defaultFaceGroup.data) {
            emoji.type = IMEmojiTypeFace;
        }
    }
    return _defaultFaceGroup;
}

- (IMExpressionGroupModel *)defaultSystemEmojiGroup
{
    if (_defaultSystemEmojiGroup == nil) {
        _defaultSystemEmojiGroup = [[IMExpressionGroupModel alloc] init];
        _defaultSystemEmojiGroup.type = IMEmojiTypeEmoji;
        _defaultSystemEmojiGroup.iconPath = @"emojiKB_group_face";
        NSString *path = [[NSBundle mainBundle] pathForResource:@"SystemEmoji" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        _defaultSystemEmojiGroup.data = [IMExpressionModel mj_objectArrayWithKeyValuesArray:data];
    }
    return _defaultSystemEmojiGroup;
}

@end

