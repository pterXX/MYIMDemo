//
//  IMFriendHelper.m
//  IMChat
//
//  Created by 李伯坤 on 16/1/27.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "IMFriendHelper.h"
#import "IMDBFriendStore.h"
#import "IMDBGroupStore.h"
#import "IMGroup+CreateAvatar.h"
#import "IMUserHelper.h"
#import "IMMessageManager+MessageRecord.h"
#import "IMChatNotificationKey.h"

static IMFriendHelper *friendHelper = nil;

@interface IMFriendHelper ()

@property (nonatomic, strong) IMDBFriendStore *friendStore;

@property (nonatomic, strong) IMDBGroupStore *groupStore;

@end

@implementation IMFriendHelper

+ (IMFriendHelper *)sharedFriendHelper
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        friendHelper = [[IMFriendHelper alloc] init];
    });
    return friendHelper;
}

- (id)init
{
    if (self = [super init]) {
        // 初始化好友数据
        _friendsData = [self.friendStore friendsDataByUid:[IMUserHelper sharedHelper].userID];
        // 初始化群数据
        self.groupsData = [self.groupStore groupsDataByUid:[IMUserHelper sharedHelper].userID];
        // 初始化标签数据
        self.tagsData = [[NSMutableArray alloc] init];
        [self p_resetFriendData];
        
        // 好友改变
        @weakify(self);
        [KIMXMPPHelper addRosterChangeNotificationObserver:self usingBlock:^{
            @strongify(self);
            XMPPRosterMemoryStorage *storage = KIMXMPPHelper.xmppRosterStorage;
            NSArray *array = [storage sortedUsersByName];
            if (array.count > 0) {
                [self updateFriendsByArray:[IMXMPPHelper storageArrayObjectConverUserArray:array] userID:[IMUserHelper sharedHelper].userID];
            }
        }];
    }
    return self;
}

#pragma mark - Public Methods -
- (IMUser *)getFriendInfoByUserID:(NSString *)userID
{
    if (userID == nil) {
        return nil;
    }
    for (IMUser *user in self.friendsData) {
        if ([user.userID isEqualToString:userID]) {
            return user;
        }
    }
    return nil;
}

- (IMGroup *)getGroupInfoByGroupID:(NSString *)groupID
{
    if (groupID == nil) {
        return nil;
    }
    for (IMGroup *group in self.groupsData) {
        if ([group.groupID isEqualToString:groupID]) {
            return group;
        }
    }
    return nil;
}

- (BOOL)updateFriendsByArray:(NSArray *)array userID:(NSString *)userID{
    if (array == nil) return NO;
    BOOL ok = [self.friendStore updateFriendsData:array forUid:userID];
    if (!ok) {
        DDLogError(@"保存好友数据到数据库失败!");
    }else{
        _friendsData = [self.friendStore friendsDataByUid:[IMUserHelper sharedHelper].userID];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self p_resetFriendData];
        });
    }
    return ok;
}

- (BOOL)deleteFriendByUserId:(NSString *)userID
{
    BOOL ok = [[IMMessageManager sharedInstance] deleteMessagesByPartnerID:userID];
    if (ok) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CHAT_VIEW_RESET object:nil];
    }
    return ok;
}

#pragma mark - Private Methods -
- (void)p_resetFriendData
{
    //  清空所有好友信息
    [self p_clearFriendArray];
    // 1、排序
    NSArray *serializeArray = [self.friendsData sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        int i;
        NSString *strA = ((IMUser *)obj1).pinyin;
        NSString *strB = ((IMUser *)obj2).pinyin;
        for (i = 0; i < strA.length && i < strB.length; i ++) {
            char a = toupper([strA characterAtIndex:i]);
            char b = toupper([strB characterAtIndex:i]);
            if (a > b) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            else if (a < b) {
                return (NSComparisonResult)NSOrderedAscending;
            }
        }
        if (strA.length > strB.length) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        else if (strA.length < strB.length){
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    // 2、分组
    for (IMUser *user in serializeArray) {
        if ([user.subscription isEqualToString:@"both"]) {
            [self.bothFriendArray addObject:user];
        }else if ([user.subscription isEqualToString:@"remove"]) {
            [self.removeFriendArray addObject:user];
        }else if ([user.subscription isEqualToString:@"to"]) {
            [self.toFriendArray addObject:user];
        }else if ([user.subscription isEqualToString:@"from"]) {
            [self.fromFriendArray addObject:user];
        }else{
            [self.noneFriendArray addObject:user];
        }
    }
    
    if (self.dataChangedBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.dataChangedBlock(self.sortGroupArray, self.pinyinInitialArray, self.totalCount);
        });
    }
    
    /*
     IMUser *user = [[self class] storageObjectConverUser:item];
     user.avatar = [UIImage imageWithData:[self.vCardAvatorModule photoDataForJID:user.userJid]];
    */
}

- (void)p_clearFriendArray{
    [self.allFriendArray removeAllObjects];
    [self.bothFriendArray removeAllObjects];
    [self.removeFriendArray removeAllObjects];
    [self.noneFriendArray removeAllObjects];
    [self.toFriendArray removeAllObjects];
    [self.fromFriendArray removeAllObjects];
}


#pragma mark - Getter
- (IMDBFriendStore *)friendStore
{
    if (_friendStore == nil) {
        _friendStore = [[IMDBFriendStore alloc] init];
    }
    return _friendStore;
}

- (IMDBGroupStore *)groupStore
{
    if (_groupStore == nil) {
        _groupStore = [[IMDBGroupStore alloc] init];
    }
    return _groupStore;
}

- (NSMutableArray *)addFriendJidArray{
    if (!_addFriendJidArray) {
        _addFriendJidArray = [NSMutableArray array];
    }
    return _addFriendJidArray;
}


- (NSArray <IMUser *> *)sortArray{
    NSArray *array = self.allFriendArray;
    _totalCount = array.count;
    if (array.count > 0) {
        return  [array sortedArrayUsingComparator:^NSComparisonResult(IMUser *  _Nonnull obj1, IMUser *  _Nonnull obj2) {
            return [obj1.pinyin compare:obj2.pinyin];
        }];
    }else{
        return @[];
    }
   
}

- (NSArray <IMUserGroup *> *)sortGroupArray{
    NSArray *array = [self sortArray]; //  已经排序所以无需对IMGroup再次排序
    NSMutableArray *enumArray = [NSMutableArray array];
    NSInteger sortInt = 0;
    for (IMUser *user in array) {
        IMUserGroup *group = [enumArray zh_objectOfBlock:^id _Nonnull(IMUserGroup * _Nonnull value) {
            return [value.groupName.pinyinInitial isEqualToString:user.pinyinInitial]?value:nil;
        }];
        if (!group){
            group = [[IMUserGroup alloc] init];
            group.groupName = user.pinyinInitial;
            group.tag = sortInt;
            [group addObject:user];
            [enumArray addObject:group];
            sortInt += 1;
        }else{
            [group addObject:user];
            enumArray = [enumArray zh_replaceOfObject:^id _Nonnull(IMUserGroup *  _Nonnull value) {
                return [value.groupName.pinyinInitial  isEqualToString:group.groupName.pinyinInitial]?group:nil;
            }].mutableCopy;
        }
    }
    return enumArray;
}

- (NSArray <NSString *> *)pinyinInitialArray{
    NSArray *array = [self sortArray]; //  已经排序所以无需对IMGroup再次排序
    NSMutableArray *enumArray = [NSMutableArray arrayWithObjects:UITableViewIndexSearch, nil];
    for (IMUser *user in array) {
        if (![enumArray containsObject:user.pinyinInitial]) [enumArray addObject:user.pinyinInitial];
    }
    return enumArray;
}

- (NSMutableArray<IMUser *> *)allFriendArray{
    if (!_allFriendArray) {
        _allFriendArray = [NSMutableArray array];
    }
    [_allFriendArray removeAllObjects];
    [_allFriendArray addObjectsFromArray:self.bothFriendArray];
    [_allFriendArray addObjectsFromArray:self.fromFriendArray];
    [_allFriendArray addObjectsFromArray:self.toFriendArray];
    return _allFriendArray;
}

- (NSMutableArray<IMUser *> *)bothFriendArray{
    if (!_bothFriendArray) {
        _bothFriendArray = [NSMutableArray array];
    }
    return _bothFriendArray;
}

- (NSMutableArray<IMUser *> *)toFriendArray{
    if (!_toFriendArray) {
        _toFriendArray = [NSMutableArray array];
    }
    return _toFriendArray;
}

- (NSMutableArray<IMUser *> *)fromFriendArray{
    if (!_fromFriendArray) {
        _fromFriendArray = [NSMutableArray array];
    }
    return _fromFriendArray;
}

- (NSMutableArray<IMUser *> *)removeFriendArray{
    if (!_removeFriendArray) {
        _removeFriendArray = [NSMutableArray array];
    }
    return _removeFriendArray;
}

- (NSMutableArray<IMUser *> *)noneFriendArray{
    if (!_noneFriendArray) {
        _noneFriendArray = [NSMutableArray array];
    }
    return _noneFriendArray;
}

@end
