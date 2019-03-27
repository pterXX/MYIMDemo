//
//  IMAddMenuView.h
//  IMChat
//
//  Created by 李伯坤 on 16/3/11.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMAddMenuItem.h"

@class IMAddMenuView;
@protocol IMAddMenuViewDelegate <NSObject>

- (void)addMenuView:(IMAddMenuView *)addMenuView didSelectedItem:(IMAddMenuItem *)item;

@end

@interface IMAddMenuView : UIView

@property (nonatomic, assign) id<IMAddMenuViewDelegate>delegate;
@property (nonatomic, copy) void (^itemSelectedAction)(IMAddMenuView *addMenuView, IMAddMenuItem *item);

/**
 *  显示AddMenu
 *
 *  @param view 父View
 */
- (void)showInView:(UIView *)view;

/**
 *  是否正在显示
 */
- (BOOL)isShow;

/**
 *  隐藏
 */
- (void)dismiss;

@end
