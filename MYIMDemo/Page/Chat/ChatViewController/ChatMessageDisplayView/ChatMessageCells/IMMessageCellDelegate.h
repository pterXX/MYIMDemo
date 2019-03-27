
//
//  IMMessageCellDelegate.h
//  IMChat
//
//  Created by 李伯坤 on 16/3/2.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IMChatUserProtocol;
@class IMMessage;
@protocol IMMessageCellDelegate <NSObject>

- (void)messageCellDidClickAvatarForUser:(id<IMChatUserProtocol>)user;

- (void)messageCellTap:(IMMessage *)message;

- (void)messageCellLongPress:(IMMessage *)message rect:(CGRect)rect;

- (void)messageCellDoubleClick:(IMMessage *)message;

@end
