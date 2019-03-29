//
//  IMMoreKeyboardDelegate.h
//  IMChat
//
//  Created by 徐世杰 on 16/2/20.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMMoreKeyboardItem.h"

@protocol IMMoreKeyboardDelegate <NSObject>
@optional
- (void)moreKeyboard:(id)keyboard didSelectedFunctionItem:(IMMoreKeyboardItem *)funcItem;

@end
