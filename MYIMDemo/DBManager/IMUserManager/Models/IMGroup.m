//
//  IMGroup.m
//  IMChat
//
//  Created by 徐世杰 on 16/3/7.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "IMGroup.h"
#import "IMUserHelper.h"

@implementation IMGroup

- (id)init
{
    if (self = [super init]) {
        [IMGroup mj_setupObjectClassInArray:^NSDictionary *{
            return @{ @"users" : @"IMUser" };
        }];
    }
    return self;
}

- (NSMutableArray *)users{
    if (_users == nil) {
        _users = [NSMutableArray array];
    }
    return _users;
}

- (NSInteger)count
{
    return self.users.count;
}

- (void)addObject:(id)anObject
{
    [self.users addObject:anObject];
}

- (id)objectAtIndex:(NSUInteger)index
{
    return [self.users objectAtIndex:index];
}

- (IMUser *)memberByUserID:(NSString *)uid
{
    for (IMUser *user in self.users) {
        if ([user.userID isEqualToString:uid]) {
            return user;
        }
    }
    return nil;
}

- (NSString *)groupName
{
    if (_groupName == nil || _groupName.length == 0) {
        for (IMUser *user in self.users) {
            if (user.showName.length > 0) {
                if (_groupName == nil || _groupName.length <= 0) {
                    _groupName = user.showName;
                }
                else {
                    _groupName = [NSString stringWithFormat:@"%@,%@", _groupName, user.showName];
                }
            }
        }
    }
    return _groupName;
}

- (NSString *)myNikeName
{
    if (_myNikeName.length == 0) {
        _myNikeName = [IMUserHelper sharedHelper].user.showName;
    }
    return _myNikeName;
}

- (NSString *)pinyin
{
    if (_pinyin == nil) {
        _pinyin = self.groupName.pinyin;
    }
    return _pinyin;
}

- (NSString *)pinyinInitial
{
    if (_pinyinInitial == nil) {
        _pinyinInitial = self.groupName.pinyinInitial;
    }
    return _pinyinInitial;
}

- (NSString *)groupAvatarPath
{
    if (_groupAvatarPath == nil) {
        _groupAvatarPath = [self.groupID stringByAppendingString:@".png"];
    }
    return _groupAvatarPath;
}

@end
