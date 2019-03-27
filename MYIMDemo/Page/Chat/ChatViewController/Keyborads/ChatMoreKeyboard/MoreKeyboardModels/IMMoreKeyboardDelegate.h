//
//  IMMoreKeyboardDelegate.h
//  IMChat
//
//  Created by 李伯坤 on 16/2/20.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMMoreKeyboardItem.h"

@protocol IMMoreKeyboardDelegate <NSObject>
@optional
- (void)moreKeyboard:(id)keyboard didSelectedFunctionItem:(IMMoreKeyboardItem *)funcItem;

@end
