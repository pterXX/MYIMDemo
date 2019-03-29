//
//  IMEmojiKBHelper.h
//  IMChat
//
//  Created by 徐世杰 on 16/2/20.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMExpressionGroupModel.h"

@interface IMEmojiKBHelper : NSObject

+ (IMEmojiKBHelper *)sharedKBHelper;

- (void)emojiGroupDataByUserID:(NSString *)userID complete:(void (^)(NSMutableArray *))complete;

- (void)updateEmojiGroupData;

@end
