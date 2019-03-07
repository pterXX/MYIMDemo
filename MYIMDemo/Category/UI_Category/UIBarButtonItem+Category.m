//
//  UIBarButtonItem+Category.m
//  MYIMDemo
//
//  Created by admin on 2019/3/7.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "UIBarButtonItem+Category.h"
#import <objc/runtime.h>

@interface UIBarButtonItem (IMAddCallBackBlock)

- (void)setIMCallBack:(IMBarButtonItemActionCallBack)callBack;
- (IMBarButtonItemActionCallBack)getIMCallBack;

@end


@implementation UIBarButtonItem (IMAddCallBackBlock)

static IMBarButtonItemActionCallBack _callBack;

- (void)setIMCallBack:(IMBarButtonItemActionCallBack)callBack {
    objc_setAssociatedObject(self, &_callBack, callBack, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (IMBarButtonItemActionCallBack)getIMCallBack {
    return (IMBarButtonItemActionCallBack)objc_getAssociatedObject(self, &_callBack);
}

@end;

@implementation UIBarButtonItem (Category)
+ (UIBarButtonItem *)barTitle:(NSString *)barTitle
                     callBack:(IMBarButtonItemActionCallBack)callBack{
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
    barItem.title = barTitle;
    barItem.target = barItem;
    barItem.action = @selector(barAction:);
    [barItem setIMCallBack:callBack];
    return barItem;
}

- (void)barAction:(UIBarButtonItem *)barItem {
    if (self.getIMCallBack) {
        self.getIMCallBack(barItem);
    }
}

@end
