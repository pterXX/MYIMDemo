//
//  IMViewController.h
//  IMChat
//
//  Created by 徐世杰 on 16/1/23.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+PopGesture.h"

@interface IMViewController : UIViewController

@property (nonatomic, strong) NSString *analyzeTitle;

/// 当前VC stutusBar的状态，仅在viewWillAppear时生效，默认LightContent
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;

@end
