//
//  IMEmojiKBHelper.h
//  IMChat
//
//  Created by 李伯坤 on 16/2/20.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMExpressionGroupModel.h"

@interface IMEmojiKBHelper : NSObject

+ (IMEmojiKBHelper *)sharedKBHelper;

- (void)emojiGroupDataByUserID:(NSString *)userID complete:(void (^)(NSMutableArray *))complete;

- (void)updateEmojiGroupData;

@end
