//
//  IMExpressionViewController.m
//  IMChat
//
//  Created by 徐世杰 on 16/2/21.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "IMExpressionViewController.h"
#import "IMExpressionChosenViewController.h"
#import "IMExpressionMoreViewController.h"
#import "IMMyExpressionViewController.h"

#define     WIDTH_EXPRESSION_SEGMENT    SCREEN_WIDTH * 0.55

@interface IMExpressionViewController ()

/// navBar分段控制器
@property (nonatomic, strong) UISegmentedControl *segmentedControl;

/// 精选表情
@property (nonatomic, strong) IMExpressionChosenViewController *expChosenVC;

/// 更多表情
@property (nonatomic, strong) IMExpressionMoreViewController *expMoreVC;

@end

@implementation IMExpressionViewController

- (void)loadView
{
    [super loadView];
    
    // navBar分段控制器
    [self.navigationItem setTitleView:self.segmentedControl];
    
    // 精选表情
    self.expChosenVC = [[IMExpressionChosenViewController alloc] init];
    [self.view addSubview:self.expChosenVC.view];
    [self addChildViewController:self.expChosenVC];
    
    // 推荐表情
    self.expMoreVC = [[IMExpressionMoreViewController alloc] init];
    [self addChildViewController:self.expMoreVC];
    
    @weakify(self);
    [self addRightBarButtonWithImage:[UIImage imageNamed:@"nav_setting"] actionBlick:^{
        @strongify(self);
        IMMyExpressionViewController *myExpressionVC = [[IMMyExpressionViewController alloc] init];
        IMPushVC(myExpressionVC);
    }];
    
    if (self.navigationController.topViewController == self) {
        [self addLeftBarButtonWithTitle:@"取消" actionBlick:^{
            @strongify(self);
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.expChosenVC requestDataIfNeed];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.segmentedControl setWidth:WIDTH_EXPRESSION_SEGMENT];
    
    if (!CGRectEqualToRect(self.expChosenVC.view.frame, self.view.bounds)) {
        [self.expChosenVC.view setFrame:self.view.bounds];
    }
    
    if (!CGRectEqualToRect(self.expMoreVC.view.frame, self.view.bounds)) {
        [self.expMoreVC.view setFrame:self.view.bounds];
    }
}

#pragma mark - # Event Response
- (void)segmentedControlChanged:(UISegmentedControl *)segmentedControl
{
    if (segmentedControl.selectedSegmentIndex == 0) {
        [self transitionFromViewController:self.expMoreVC toViewController:self.expChosenVC duration:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:nil];
        [self.expChosenVC requestDataIfNeed];
    }
    else {
        [self transitionFromViewController:self.expChosenVC toViewController:self.expMoreVC duration:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:nil];
        [self.expMoreVC requestDataIfNeed];
    }
}

#pragma mark - # Getter
- (UISegmentedControl *)segmentedControl
{
    if (_segmentedControl == nil) {
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"精选表情", @"更多表情"]];
        [_segmentedControl setWidth:WIDTH_EXPRESSION_SEGMENT];
        [_segmentedControl setSelectedSegmentIndex:0];
        [_segmentedControl addTarget:self action:@selector(segmentedControlChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}

@end
