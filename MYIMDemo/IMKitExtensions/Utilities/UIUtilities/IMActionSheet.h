//
//  IMActionSheet.h
//  IMChat
//
//  Created by 徐世杰 on 16/5/1.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IMActionSheet;
@protocol IMActionSheetDelegate <NSObject>

@optional;
- (void)actionSheet:(IMActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end


@interface IMActionSheet : UIView

/// 按钮个数
@property (nonatomic, assign, readonly) NSInteger numberOfButtons;

/// 取消按钮index
@property (nonatomic, assign, readonly) NSInteger cancelButtonIndex;

/// 高亮按钮index
@property (nonatomic, assign, readonly) NSInteger destructiveButtonIndex;

@property (nonatomic, weak) id<IMActionSheetDelegate> delegate;

/// 点击事件响应block
@property (nonatomic, copy) void (^clickAction)(NSInteger buttonIndex);

- (id)initWithTitle:(NSString *)title
           delegate:(id<IMActionSheetDelegate>)delegate
  cancelButtonTitle:(NSString *)cancelButtonTitle
destructiveButtonTitle:(NSString *)destructiveButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ...;


- (id)initWithTitle:(NSString *)title
        clickAction:(void (^)(NSInteger buttonIndex))clickAction
  cancelButtonTitle:(NSString *)cancelButtonTitle
destructiveButtonTitle:(NSString *)destructiveButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ...;

/**
 *  显示ActionSheet
 */
- (void)show;

/**
 *  根据index获取按钮标题
 *
 *  @param  buttonIndex     按钮index
 */
- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex;

@end
