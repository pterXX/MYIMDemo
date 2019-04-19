//
//  IMBaseViewController.m
//  MYIMDemo
//
//  Created by 徐世杰 on 2019/2/28.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "IMBaseViewController.h"

@interface IMBaseViewController ()
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
@property (nonatomic, assign) BOOL statusBarHidden;
@property (nonatomic, assign) BOOL changeStatusBarAnimated;
@end

@implementation IMBaseViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self im_addSubViews];
    [self im_bindViewModel];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self im_layoutNavigation];
    [self im_getNewData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self im_hideHUD];
}

#pragma mark - private
- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle{
    _statusBarStyle = statusBarStyle;
}

/**
 *  去除nav 上的line
 */
- (void)im_removeNavgationBarLine {
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        
        NSArray *list=self.navigationController.navigationBar.subviews;
        
        for (id obj in list) {
            
            if ([obj isKindOfClass:[UIImageView class]]) {
                
                UIImageView *imageView=(UIImageView *)obj;
                
                NSArray *list2=imageView.subviews;
                
                for (id obj2 in list2) {
                    
                    if ([obj2 isKindOfClass:[UIImageView class]]) {
                        
                        UIImageView *imageView2=(UIImageView *)obj2;
                        
                        imageView2.hidden=YES;
                        
                    }
                }
            }
        }
    }
}

- (void)setIsExtendLayout:(BOOL)isExtendLayout {
    if (!isExtendLayout) {
        [self initializeSelfVCSetting];
    }
}

- (void)initializeSelfVCSetting {
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)changeStatusBarStyle:(UIStatusBarStyle)statusBarStyle
             statusBarHidden:(BOOL)statusBarHidden
     changeStatusBarAnimated:(BOOL)animated {
    
    self.statusBarStyle=statusBarStyle;
    self.statusBarHidden=statusBarHidden;
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            [self setNeedsStatusBarAppearanceUpdate];
        }];
    }
    else{
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)hideNavigationBar:(BOOL)isHide
                 animated:(BOOL)animated{
    
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            self.navigationController.navigationBarHidden=isHide;
        }];
    }
    else{
        self.navigationController.navigationBarHidden=isHide;
    }
}

- (void)layoutNavigationBar:(UIImage*)backGroundImage
                 titleColor:(UIColor*)titleColor
                  titleFont:(UIFont*)titleFont
          leftBarButtonItem:(UIBarButtonItem*)leftItem
         rightBarButtonItem:(UIBarButtonItem*)rightItem {
    
    if (backGroundImage) {
        [self.navigationController.navigationBar setBackgroundImage:backGroundImage forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    }
    if (titleColor&&titleFont) {
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:titleColor,NSFontAttributeName:titleFont}];
    }
    else if (titleFont) {
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:titleFont}];
    }
    else if (titleColor){
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:titleColor}];
    }
    if (leftItem) {
        self.navigationItem.leftBarButtonItem=leftItem;
    }
    if (rightItem) {
        self.navigationItem.rightBarButtonItem=rightItem;
    }
}

#pragma mark - 屏幕旋转
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    
    return UIInterfaceOrientationPortrait;
}

- (void)showToViewController:(UIViewController *)vc animated:(BOOL)animated{
    if (self.navigationController) {
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self presentViewController:vc animated:animated completion:nil];
    }
}

#pragma mark -
/**
 *  添加控件
 */
- (void)im_addSubViews{
}

/**
 *  绑定
 */
- (void)im_bindViewModel {}

/**
 *  设置navation
 */
- (void)im_layoutNavigation {}

/**
 *  初次获取数据
 */
- (void)im_getNewData {}

- (void)im_showHUD{
//    [LSProgressHUD show];
    
}

- (void)im_hideHUD{
//    [LSProgressHUD hide];
}

/**
 *  初始化一个nav
 */
- (IMBaseNavigationController *)im_initializeNavigationController{
    return [[self class] im_initializeNavigationControllerForVc:self];
}

+ (IMBaseNavigationController *)im_initializeNavigationControllerForVc:(UIViewController *)vc{
    IMBaseNavigationController *nav = [[IMBaseNavigationController alloc] initWithRootViewController:vc];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    vc.edgesForExtendedLayout = UIRectEdgeNone;
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    [backBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [backBtn setImage:[UIImage imageNavBack] forState:UIControlStateNormal];
    [backBtn addIMClickAction:^(UIButton *button) {
        [self backHandleForVc:vc];
    }];
    vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    return nav;
}

/**
 * 返回的操作
 */
- (void)im_backHandle{
    [[self class] backHandleForVc:self];
}

+ (void)backHandleForVc:(UIViewController *)vc{
    if (vc.navigationController) {
        if (vc.navigationController.viewControllers.firstObject == vc) {
            [vc.navigationController dismissViewControllerAnimated:YES completion:nil];
        }else{
            [vc.navigationController popViewControllerAnimated:YES];
        }
    }else{
        [vc dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.isTouchEndEditing) {
        [self.view endEditing:YES];
    }
}

@end
