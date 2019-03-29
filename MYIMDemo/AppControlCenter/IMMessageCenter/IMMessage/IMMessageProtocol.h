//
//  IMMessageProtocol.h
//  IMChat
//
//  Created by libokun on 16/3/28.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMMessageFrame.h"

@protocol IMMessageProtocol <NSObject>

- (NSString *)messageCopy;

- (NSString *)conversationContent;

@end
