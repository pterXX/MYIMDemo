//
//  IMUser.h
//  MYIMDemo
//
//  Created by admin on 2019/3/5.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMUser : NSObject
@property (nonatomic ,strong) NSString *userID;//  用户ID
@property (nonatomic ,strong) NSString *userName;//  用户名
@property (nonatomic ,strong) NSString *nickName;// 昵称
@property (nonatomic ,strong) NSString *remarkName;// 昵称
@property (nonatomic ,strong) NSString *avatarUrl;//  头像
@property (nonatomic ,strong) NSString *pinyin;//  拼音
@property (nonatomic ,strong) NSString *pinyinInitial;//
@end

NS_ASSUME_NONNULL_END
