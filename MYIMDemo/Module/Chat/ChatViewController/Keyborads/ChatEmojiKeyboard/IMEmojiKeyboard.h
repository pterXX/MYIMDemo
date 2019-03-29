//
//  IMEmojiKeyboard.h
//  IMChat
//
//  Created by 徐世杰 on 16/2/17.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "IMBaseKeyboard.h"
#import "IMEmojiKeyboardDelegate.h"
#import "IMEmojiGroupControl.h"
#import "IMEmojiGroupDisplayView.h"

@interface IMEmojiKeyboard : IMBaseKeyboard

@property (nonatomic, strong) NSMutableArray *emojiGroupData;

@property (nonatomic, assign) id<IMEmojiKeyboardDelegate> delegate;

@property (nonatomic, strong) IMExpressionGroupModel *curGroup;

@property (nonatomic, strong) IMEmojiGroupDisplayView *displayView;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) IMEmojiGroupControl *groupControl;

+ (IMEmojiKeyboard *)keyboard;

@end
