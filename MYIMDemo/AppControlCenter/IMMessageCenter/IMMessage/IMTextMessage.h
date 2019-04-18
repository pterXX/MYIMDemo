//
//  IMTextMessage.h
//  IMChat
//
//  Created by libokun on 16/3/28.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "IMMessage.h"

@interface IMTextMessage : IMMessage

@property (nonatomic, strong) NSString *text;                       // 文字信息

@property (nonatomic, strong) NSAttributedString *attrText;         // 格式化的文字信息（仅展示用）

@end
