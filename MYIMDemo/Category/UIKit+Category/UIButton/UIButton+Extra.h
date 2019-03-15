//
//  UIButton+IMExtra.h
//  proj
//
//  Created by asdasd on 2017/12/20.
//  Copyright © 2017年 asdasd. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^IMButtonActionCallBack)(UIButton *button);

@interface UIButton (Extra)


/**
 *  @brief replace the method 'addTarget:forControlEvents:'
 */
- (void)addIMCallBackAction:(IMButtonActionCallBack)callBack forControlEvents:(UIControlEvents)controlEvents;

/**
 *  @brief replace the method 'addTarget:forControlEvents:UIControlEventTouchUpInside'
 *  the property 'alpha' being 0.5 while 'UIControlEventTouchUpInside'
 */
- (void)addIMClickAction:(IMButtonActionCallBack)callBack;

@end
