//
//  IMShortcutMethod.h
//  MYIMDemo
//
//  Created by 徐世杰 on 2019/3/1.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 判断是否刘海屏

 @return YES 是刘海屏幕
 */
BOOL isNotchScreen();


/**
 为viewController 添加一个UINavigationController

 @param viewController 当前需要添加vc
 @return NavigationController
 */
UINavigationController *addNavigationController(UIViewController *viewController);


/**
 tabBarItem添加标题 图片

 @param tabBarItem 当前需要添加属性的UITabBarItem
 @param tilte 标题
 @param image 图片
 @param imageHL 选中图片
 */
void initTabBarItem(UITabBarItem *tabBarItem, NSString *tilte, NSString *image, NSString *imageHL);

NS_ASSUME_NONNULL_END
