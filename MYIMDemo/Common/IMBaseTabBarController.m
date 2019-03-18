//
//  IMBaseTabBarController.m
//  MYIMDemo
//
//  Created by admin on 2019/3/8.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "IMBaseTabBarController.h"

@interface IMBaseTabBarController ()<UITabBarControllerDelegate>
@property (nonatomic ,strong) NSMutableArray<IMBaseTabBarCtrSubVcAction> *subVcActionDataSource;
@end

@implementation IMBaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    // Do any additional setup after loading the view.
    [self addNotification];
}

- (void)addNotification{
   
}

- (NSMutableArray *)subVcActionDataSource{
    if (_subVcActionDataSource == nil) {
        _subVcActionDataSource = [NSMutableArray array];
    }
    return _subVcActionDataSource;
}

- (void)addSubController:( UIViewController * _Nonnull )vc action:(_Nonnull IMBaseTabBarCtrSubVcAction)action{
    if (vc == nil || action == nil) return;
    NSMutableArray *array = self.viewControllers.mutableCopy;
    if (array == nil) array = [NSMutableArray array];
    [array addObject:vc];
    [self.subVcActionDataSource addObject:action];
    self.viewControllers = array;
}

- (void)controller:(UIViewController *)controller Title:(NSString *)title tabBarItemImage:(UIImage *)image tabBarItemSelectedImage:(UIImage *)selectedImage textColor:(UIColor *)textColor
{
    if ([controller isKindOfClass:[UINavigationController class]]) {
        ((UINavigationController *)controller).topViewController.title = title;
    }else{
        controller.title = title;
    }
    controller.tabBarItem.image = image;
    // 设置 tabbarItem 选中状态的图片(不被系统默认渲染,显示图像原始颜色)
    UIImage *imageHome = selectedImage;
    imageHome = [imageHome imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [controller.tabBarItem setSelectedImage:imageHome];
    // 设置 tabbarItem 选中状态下的文字颜色(不被系统默认渲染,显示文字自定义颜色)
    NSDictionary *dictHome = [NSDictionary dictionaryWithObject:textColor forKey:NSForegroundColorAttributeName];
    [controller.tabBarItem setTitleTextAttributes:dictHome forState:UIControlStateSelected];
}

#pragma mark - UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if (_subVcActionDataSource.count == tabBarController.viewControllers.count) {
        _subVcActionDataSource[tabBarController.selectedIndex](viewController.tabBarItem,tabBarController);
    }
}




@end

@implementation IMBaseTabBarController(Class)

@end
