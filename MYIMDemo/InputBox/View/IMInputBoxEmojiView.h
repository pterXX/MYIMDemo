//
//  IMInputBoxEmojiView.h
//  KXiniuCloud
//
//  Created by eims on 2018/5/10.
//  Copyright © 2018年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IMInputBoxViewDelegate.h"
#import "IMInputBoxEmojiMenuView.h"

@interface IMInputBoxEmojiView : UIView

@property (nonatomic, assign) id<IMInputBoxViewDelegate> delegate;
// 表情菜单
@property (nonatomic, strong) IMInputBoxEmojiMenuView    *menuView;

@end
