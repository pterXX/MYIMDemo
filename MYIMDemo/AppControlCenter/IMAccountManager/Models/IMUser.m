
//
//  IMUser.m
//  IMChat
//
//  Created by 徐世杰 on 16/1/23.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "IMUser.h"

@implementation IMUser

+ (IMUser *)user:(XMPPJID *)jid{
    IMUser *user = [[IMUser alloc] init];
    user.userJid = jid;
    return user;
}

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
    NSString *str = self.remarkName.length > 0 ? self.remarkName : (self.nikeName.length > 0 ? self.nikeName : (self.username?self.username:self.userJid.user));
    //    return IMStirngReplace(str, IMStirngFormat(@"@%@"), IM_XMPP_DOMAIN);
    return str;
}

- (IMUserDetail *)detailInfo
{
    if (_detailInfo == nil) {
        _detailInfo = [[IMUserDetail alloc] init];
    }
    return _detailInfo;
}

- (XMPPJID *)userJid{
    if (_userJid == nil) {
        _userJid = [IMXMPPHelper jid:self.userID];
    }
    return _userJid;
}

- (NSString *)subscription{
    if (_subscription == nil) {
        _subscription = @"none";
    }
    return _subscription;
}

- (NSString *)ask{
    if (_ask == nil) {
        _ask = @"unsubscribe";
    }
    return _ask;
}

- (UIImage *)avatar{
    if (_avatar == nil) {
        NSString *filePath = nil;
        BOOL ok = [self.userID isEqualToString:[IMUserHelper sharedHelper].userID];
        if (ok) {
          filePath = [NSFileManager pathUserAvatar:self.userID];
        }else{
          filePath = [NSFileManager pathContactsAvatar:self.userID];
        }
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        if (data) {
            _avatar = [UIImage imageWithData:data];
        }else{
            UIImage *image = [KIMXMPPHelper userAvatarForJid:self.userJid];
            _avatar = image;
        }
    }
    return _avatar;
}
@end


