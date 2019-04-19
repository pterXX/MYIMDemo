//
//  BehaviorCalendarScrollView.h
//  Demo
//
//  Created by admin on 2019/4/19.
//  Copyright © 2019 admin. All rights reserved.
//

#import "LTSCalendarScrollView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BehaviorCalendarScrollView : LTSCalendarScrollView
//  重写父类方法
@property (nonatomic ,weak) UIViewController *viewController;
@end

NS_ASSUME_NONNULL_END
