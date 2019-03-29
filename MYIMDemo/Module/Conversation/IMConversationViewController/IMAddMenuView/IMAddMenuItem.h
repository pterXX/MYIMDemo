//
//  IMAddMenuItem.h
//  IMChat
//
//  Created by 徐世杰 on 16/3/11.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, IMAddMneuType) {
    IMAddMneuTypeGroupChat = 0,
    IMAddMneuTypeAddFriend,
    IMAddMneuTypeScan,
    IMAddMneuTypeWallet,
};

@interface IMAddMenuItem : NSObject

@property (nonatomic, assign) IMAddMneuType type;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *iconPath;

@property (nonatomic, strong) NSString *className;

+ (IMAddMenuItem *)createWithType:(IMAddMneuType)type title:(NSString *)title iconPath:(NSString *)iconPath className:(NSString *)className;

@end
