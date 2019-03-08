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
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if (_subVcActionDataSource.count == tabBarController.viewControllers.count) {
        _subVcActionDataSource[tabBarController.selectedIndex](viewController.tabBarItem,tabBarController);
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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

@end

@implementation IMBaseTabBarController(Class)
@end
