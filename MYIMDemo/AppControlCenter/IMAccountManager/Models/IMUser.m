
//
//  IMUser.m
//  IMChat
//
//  Created by 李伯坤 on 16/1/23.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "IMUser.h"
#import "NSString+PinYin.h"

@implementation IMUser

- (id)init
{
    if (self = [super init]) {
        [IMUser mj_setupObjectClassInArray:^NSDictionary *{
            return @{ @"detailInfo" : @"IMUserDetail",
                      @"userSetting" : @"IMUserSetting",
                      @"chatSetting" : @"IMUserChatSetting",};
        }];
    }
    return self;
}

- (void)setUsername:(NSString *)username
{
    if ([username isEqualToString:_username]) {
        return;
    }
    _username = username;
    if (self.remarkName.length == 0 && self.nikeName.length == 0 && self.username.length > 0) {
        self.pinyin = username.pinyin;
        self.pinyinInitial = username.pinyinInitial;
    }
}

- (void)setNikeName:(NSString *)nikeName
{
    if ([nikeName isEqualToString:_nikeName]) {
        return;
    }
    _nikeName = nikeName;
    if (self.remarkName.length == 0 && self.nikeName.length > 0) {
        self.pinyin = nikeName.pinyin;
        self.pinyinInitial = nikeName.pinyinInitial;
    }
}

- (void)setRemarkName:(NSString *)remarkName
{
    if ([remarkName isEqualToString:_remarkName]) {
        return;
    }
    _remarkName = remarkName;
    if (_remarkName.length > 0) {
        self.pinyin = remarkName.pinyin;
        self.pinyinInitial = remarkName.pinyinInitial;
    }
}

#pragma mark - Getter
- (NSString *)showName
{
    return self.remarkName.length > 0 ? self.remarkName : (self.nikeName.length > 0 ? self.nikeName : self.username);
}

- (IMUserDetail *)detailInfo
{
    if (_detailInfo == nil) {
        _detailInfo = [[IMUserDetail alloc] init];
    }
    return _detailInfo;
}

@end
