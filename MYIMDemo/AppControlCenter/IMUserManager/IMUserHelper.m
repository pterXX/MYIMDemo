//
//  IMUserHelper.m
//  IMChat
//
//  Created by 徐世杰 on 16/2/6.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "IMUserHelper.h"
#import "IMDBUserStore.h"

#define KLoginUid @"loginUid"
#define KLoginPassword @"loginPassword"

@implementation IMUserHelper
@synthesize user = _user;

+ (IMUserHelper *)sharedHelper
{
    static IMUserHelper *helper;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        helper = [[IMUserHelper alloc] init];
    });
    return helper;
}



- (void)loginTestAccount
{
    IMUser *user = [[IMUser alloc] init];
    user.userID              = @"admin1@admins";
    user.avatarURL           = @"http://p1.qq181.com/cms/120506/2012050623111097826.jpg";
    user.nikeName            = @"徐世杰";
    user.username            = @"xuqinngsong";
    user.detailInfo.qqNumber = @"7281023814";
    user.detailInfo.email    = @"7281023814@qq.com";
    user.detailInfo.location = @"垫江";
    user.detailInfo.sex      = @"男";
    user.detailInfo.motto    = @"Hello world!";
    user.detailInfo.momentsWallURL = @"http://pic1.win4000.com/wallpaper/c/5791e49b37a5c.jpg";
    
    [self setUser:user];
}

- (void)setUser:(IMUser *)user
{
    _user = user;
    IMDBUserStore *userStore = [[IMDBUserStore alloc] init];
    if (![userStore updateUser:user]) {
        DDLogError(@"登录数据存库失败");
    }
    
    [IMUserDefaults setObject:user.userID forKey:KLoginUid];
}

- (IMUser *)user{
    if (!_user) {
        if (self.userID.length > 0) {
            IMDBUserStore *userStore = [[IMDBUserStore alloc] init];
            _user = [userStore userByID:self.userID];
            if (!_user) {
                [IMUserDefaults removeObjectForKey:KLoginUid];
                [IMUserDefaults removeObjectForKey:KLoginPassword];
            }
        }
    }
    return _user;
}

- (NSString *)userID{
    NSString *uid = [IMUserDefaults objectForKey:KLoginUid];
    return uid;
}

- (void)setPassword:(NSString *)password{
    [IMUserDefaults setObject:IMNoNilString(password) forKey:KLoginPassword];
}

- (NSString *)password{
    NSString *password = [IMUserDefaults objectForKey:KLoginPassword];
    return password;
}

- (NSString *)userAccount{
    if (_userAccount == nil) _userAccount = self.userID;
    return _userAccount;
}

- (BOOL)isLogin{
    return self.user.userID.length > 0;
}

- (BOOL)signOut{
    BOOL ok = YES;
    if (self.isLogin || self.userID) {
        IMDBUserStore *userStore = [[IMDBUserStore alloc] init];
        if (![userStore deleteUsersByUid:self.userID]) {
            DDLogError(@"登录数据存库失败");
            ok = NO;
        }else{
            [IMUserDefaults removeObjectForKey:KLoginUid];
            [IMUserDefaults removeObjectForKey:KLoginPassword];
        }
    }
    return ok;
}

- (void)clearFriendArray{
    [self.allFriendArray removeAllObjects];
    [self.bothFriendArray removeAllObjects];
    [self.removeFriendArray removeAllObjects];
    [self.noneFriendArray removeAllObjects];
    [self.toFriendArray removeAllObjects];
    [self.fromFriendArray removeAllObjects];
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
    return  [array zh_SortObjectsUsingBlock:^BOOL(IMUser *  _Nonnull obj1, IMUser *  _Nonnull obj2) {
        return [obj1.pinyin compare:obj2.pinyin];
    }];
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
    NSMutableArray *enumArray = [NSMutableArray array];
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
