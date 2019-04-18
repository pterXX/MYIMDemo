//
//  IMExpressionMessage.h
//  IMChat
//
//  Created by libokun on 16/3/28.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "IMMessage.h"
#import "IMExpressionModel.h"

@interface IMExpressionMessage : IMMessage

@property (nonatomic, strong) IMExpressionModel *emoji;

@property (nonatomic, strong, readonly) NSString *path;

@property (nonatomic, strong, readonly) NSString *url;

@property (nonatomic, assign, readonly) CGSize emojiSize;

@end
