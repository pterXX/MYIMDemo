//
//  IMMessageManagerChatVCDelegate.h
//  IMChat
//
//  Created by 徐世杰 on 16/3/21.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IMMessageManagerChatVCDelegate <NSObject>

- (void)didReceivedMessage:(IMMessage *)message;

@end
