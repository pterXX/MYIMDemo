//
//  IMEmojiGroupControl.h
//  IMChat
//
//  Created by 徐世杰 on 16/2/19.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMExpressionGroupModel.h"

typedef NS_ENUM(NSInteger, IMGroupControlSendButtonStatus) {
    IMGroupControlSendButtonStatusGray,
    IMGroupControlSendButtonStatusBlue,
    IMGroupControlSendButtonStatusNone,
};

@class IMEmojiGroupControl;
@protocol IMEmojiGroupControlDelegate <NSObject>

- (void)emojiGroupControl:(IMEmojiGroupControl*)emojiGroupControl didSelectedGroup:(IMExpressionGroupModel *)group;

- (void)emojiGroupControlEditButtonDown:(IMEmojiGroupControl *)emojiGroupControl;

- (void)emojiGroupControlEditMyEmojiButtonDown:(IMEmojiGroupControl *)emojiGroupControl;

- (void)emojiGroupControlSendButtonDown:(IMEmojiGroupControl *)emojiGroupControl;

@end

@interface IMEmojiGroupControl : UIView

@property (nonatomic, assign) IMGroupControlSendButtonStatus sendButtonStatus;

@property (nonatomic, strong) NSMutableArray *emojiGroupData;

@property (nonatomic, assign) id<IMEmojiGroupControlDelegate>delegate;

- (void)selectEmojiGroupAtIndex:(NSInteger)index;

@end
