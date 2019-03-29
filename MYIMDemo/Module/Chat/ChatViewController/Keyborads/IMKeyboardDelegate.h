//
//  IMKeyboardDelegate.h
//  IMChat
//
//  Created by 徐世杰 on 16/2/17.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IMKeyboardDelegate <NSObject>

@optional
@optional
- (void)chatKeyboardWillShow:(id)keyboard animated:(BOOL)animated;

- (void)chatKeyboardDidShow:(id)keyboard animated:(BOOL)animated;

- (void)chatKeyboardWillDismiss:(id)keyboard animated:(BOOL)animated;

- (void)chatKeyboardDidDismiss:(id)keyboard animated:(BOOL)animated;

- (void)chatKeyboard:(id)keyboard didChangeHeight:(CGFloat)height;

@end
