//
//  UIButton+IMExtra.m
//  proj
//
//  Created by asdasd on 2017/12/20.
//  Copyright © 2017年 asdasd. All rights reserved.
//

#import "UIButton+Extra.h"
#import <objc/runtime.h>


/**
 *  @brief add action callback to uibutton
 */
@interface UIButton (IMAddCallBackBlock)

- (void)setIMCallBack:(IMButtonActionCallBack)callBack;
- (IMButtonActionCallBack)getIMCallBack;

@end

@implementation UIButton (IMAddCallBackBlock)

static IMButtonActionCallBack _callBack;

- (void)setIMCallBack:(IMButtonActionCallBack)callBack {
    objc_setAssociatedObject(self, &_callBack, callBack, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (IMButtonActionCallBack)getIMCallBack {
    return (IMButtonActionCallBack)objc_getAssociatedObject(self, &_callBack);
}

@end;


@implementation UIButton (Extra)

/**
 *  @brief replace the method 'addTarget:forControlEvents:UIControlEventTouchUpInside'
 *  the property 'alpha' being 0.5 while 'UIControlEventTouchUpInside'
 */
- (void)addIMClickAction:(IMButtonActionCallBack)callBack {
    [self addIMCallBackAction:callBack forControlEvents:(UIControlEventTouchUpInside)];
    [self addTarget:self action:@selector(imTouchDownAction:) forControlEvents:(UIControlEventTouchDown)];
    [self addTarget:self action:@selector(imTouchUpAction:) forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel | UIControlEventTouchDragOutside)];
}

/**
 *  @brief replace the method 'addTarget:forControlEvents:'
 */
- (void)addIMCallBackAction:(IMButtonActionCallBack)callBack forControlEvents:(UIControlEvents)controlEvents{
    [self setIMCallBack:callBack];
    [self addTarget:self action:@selector(imButtonAction:) forControlEvents:controlEvents];
}

- (void)imButtonAction:(UIButton *)btn {
    self.getIMCallBack(btn);
}

- (void)imTouchDownAction:(UIButton *)btn {
    btn.enabled = NO;
    btn.alpha = 0.5f;
}

- (void)imTouchUpAction:(UIButton *)btn {
    btn.enabled = YES;
    btn.alpha = 1.0f;
}

@end
