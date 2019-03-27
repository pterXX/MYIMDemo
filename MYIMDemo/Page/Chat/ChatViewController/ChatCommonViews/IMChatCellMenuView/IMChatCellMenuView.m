//
//  IMChatCellMenuView.m
//  IMChat
//
//  Created by 李伯坤 on 16/3/16.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "IMChatCellMenuView.h"

@interface IMChatCellMenuView ()

@property (nonatomic, strong) UIMenuController *menuController;

@end

@implementation IMChatCellMenuView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor clearColor]];
        self.menuController = [UIMenuController sharedMenuController];
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [self addGestureRecognizer:tapGR];
    }
    return self;
}

- (void)showInView:(UIView *)view withMessageType:(IMMessageType)messageType rect:(CGRect)rect actionBlock:(void (^)(IMChatMenuItemType))actionBlock
{
    _isShow = YES;
    [self setFrame:view.bounds];
    [view addSubview:self];
    [self setActionBlcok:actionBlock];
    [self setMessageType:messageType];
    
    [self.menuController setTargetRect:rect inView:self];
    [self becomeFirstResponder];
    [self.menuController setMenuVisible:YES animated:YES];
}

- (void)setMessageType:(IMMessageType)messageType
{
    UIMenuItem *copy = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyButtonDown:)];
    UIMenuItem *transmit = [[UIMenuItem alloc] initWithTitle:@"转发" action:@selector(transmitButtonDown:)];
    UIMenuItem *collect = [[UIMenuItem alloc] initWithTitle:@"收藏" action:@selector(collectButtonDown:)];
    UIMenuItem *del = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteButtonDown:)];
    [self.menuController setMenuItems:@[copy, transmit, collect, del]];
}

- (void)dismiss
{
    _isShow = NO;
    if (self.actionBlcok) {
        self.actionBlcok(IMChatMenuItemTypeCancel);
    }
    [self.menuController setMenuVisible:NO animated:YES];
    [self removeFromSuperview];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark - Event Response -
- (void)copyButtonDown:(UIMenuController *)sender
{
    [self p_clickedMenuItemType:IMChatMenuItemTypeCopy];
}

- (void)transmitButtonDown:(UIMenuController *)sender
{
    [self p_clickedMenuItemType:IMChatMenuItemTypeCopy];
}

- (void)collectButtonDown:(UIMenuController *)sender
{
    [self p_clickedMenuItemType:IMChatMenuItemTypeCopy];
}

- (void)deleteButtonDown:(UIMenuController *)sender
{
    [self p_clickedMenuItemType:IMChatMenuItemTypeDelete];
}

#pragma mark - Private Methods -
- (void)p_clickedMenuItemType:(IMChatMenuItemType)type
{
    _isShow = NO;
    [self removeFromSuperview];
    if (self.actionBlcok) {
        self.actionBlcok(type);
    }
}

@end
