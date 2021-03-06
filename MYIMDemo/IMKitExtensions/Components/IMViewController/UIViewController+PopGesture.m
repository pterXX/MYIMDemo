//
//  UIViewController+PopGesture.m
//  IMChat
//
//  Created by 徐世杰 on 2017/9/26.
//  Copyright © 2017年 徐世杰. All rights reserved.
//

#import "UIViewController+PopGesture.h"

#pragma mark - ## UINavigationController (IMViewController)

@interface UINavigationController (IMViewController)

@property (nonatomic, strong, readonly) id systemInteractivePopGestureRecognizerDelegate;

@end

@implementation UINavigationController (IMViewController)

+ (void)load
{
    IMExchangeMethod(@selector(initWithRootViewController:), @selector(__tt_initWithRootViewController:));
}

- (id)__tt_initWithRootViewController:(UIViewController *)rootViewController
{
    [self __tt_initWithRootViewController:rootViewController];
    [self setAssociatedObject:self.interactivePopGestureRecognizer.delegate forKey:@"systemInteractivePopGestureRecognizerDelegate" association:IMAssociationStrong];
    return self;
}

- (id)systemInteractivePopGestureRecognizerDelegate
{
    return [self associatedObjectForKey:@"systemInteractivePopGestureRecognizerDelegate"];
}

@end

@implementation UIViewController (PopGesture)

+ (void)load
{
    IMExchangeMethod(@selector(viewWillAppear:), @selector(__tt_viewWillAppear:));
}

- (void)__tt_viewWillAppear:(BOOL)animated
{
    [self __tt_viewWillAppear:animated];
    
    if ([self.navigationController.childViewControllers containsObject:self]) {
        if (self.disablePopGesture) {
            if ([self.navigationController respondsToSelector:@selector(systemInteractivePopGestureRecognizerDelegate)]) {
                self.navigationController.interactivePopGestureRecognizer.delegate = self;
            }
            else {
                NSLog(@"不能禁用右滑手势");
            }
        }
        else {
            if ([self.navigationController respondsToSelector:@selector(systemInteractivePopGestureRecognizerDelegate)]) {
                id delegate = [self.navigationController valueForKey:@"systemInteractivePopGestureRecognizerDelegate"];
                if (delegate && self.navigationController.interactivePopGestureRecognizer.delegate != delegate) {
                    self.navigationController.interactivePopGestureRecognizer.delegate = delegate;
                }
            }
        }
    }
}

#pragma mark - # Public Methods
- (void)setDisablePopGesture:(BOOL)disablePopGesture
{
    [self setAssociatedObject:@(disablePopGesture) forKey:@"__tt_disablePopGesture" association:IMAssociationStrong];
    if (disablePopGesture && [self.navigationController.childViewControllers containsObject:self]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}
- (BOOL)disablePopGesture
{
    return [[self associatedObjectForKey:@"__tt_disablePopGesture"] boolValue];
}

#pragma mark - # Delegate
//MARK: UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return NO;
}

@end
