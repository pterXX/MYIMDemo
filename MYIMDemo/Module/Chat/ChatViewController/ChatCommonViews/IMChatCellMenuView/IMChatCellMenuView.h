//
//  IMChatCellMenuView.h
//  IMChat
//
//  Created by 徐世杰 on 16/3/16.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMMessageConstants.h"

typedef NS_ENUM(NSInteger, IMChatMenuItemType) {
    IMChatMenuItemTypeCancel,
    IMChatMenuItemTypeCopy,
    IMChatMenuItemTypeDelete,
};

@interface IMChatCellMenuView : UIView

@property (nonatomic, assign, readonly) BOOL isShow;

@property (nonatomic, assign) IMMessageType messageType;

@property (nonatomic, copy) void (^actionBlcok)();

- (void)showInView:(UIView *)view withMessageType:(IMMessageType)messageType rect:(CGRect)rect actionBlock:(void (^)(IMChatMenuItemType))actionBlock;

- (void)dismiss;

@end
