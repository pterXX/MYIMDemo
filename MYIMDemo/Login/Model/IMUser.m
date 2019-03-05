//
//  IMUser.m
//  MYIMDemo
//
//  Created by admin on 2019/3/5.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "IMUser.h"

@implementation IMUser


- (void)setUserName:(NSString *)userName{
    if ([userName isEqualToString:_userName]) {
        return;
    }
    _userName = userName;
    if (self.remarkName.length == 0 && self.nickName.length == 0 && self.userName.length > 0) {
        self.pinyin = userName.pinyin;
        self.pinyinInitial = userName.pinyinInitial;
    }
}

- (void)setNickName:(NSString *)nickName{
    if ([nickName isEqualToString:_nickName]) {
        return;
    }
    _nickName = nickName;
    if (self.remarkName.length == 0 && self.nickName.length > 0) {
        self.pinyin = nickName.pinyin;
        self.pinyinInitial = nickName.pinyinInitial;
    }
}

- (void)setRemarkName:(NSString *)remarkName{
    if ([remarkName isEqualToString:_remarkName]) {
        return;
    }
    _remarkName = remarkName;
    if (_remarkName.length > 0) {
        self.pinyin = remarkName.pinyin;
        self.pinyinInitial = remarkName.pinyinInitial;
    }
}


@end
