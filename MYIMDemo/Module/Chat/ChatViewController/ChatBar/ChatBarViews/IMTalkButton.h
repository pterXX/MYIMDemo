//
//  IMTalkButton.h
//  IMChat
//
//  Created by 徐世杰 on 16/7/11.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMTalkButton : UIView

@property (nonatomic, strong) NSString *normalTitle;
@property (nonatomic, strong) NSString *cancelTitle;
@property (nonatomic, strong) NSString *highlightTitle;

@property (nonatomic, strong) UIColor *highlightColor;

@property (nonatomic, strong) UILabel *titleLabel;

- (void)setTouchBeginAction:(void (^)())touchBegin
      willTouchCancelAction:(void (^)(BOOL cancel))willTouchCancel
             touchEndAction:(void (^)())touchEnd
          touchCancelAction:(void (^)())touchCancel;

@end
