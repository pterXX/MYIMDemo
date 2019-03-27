//
//  IMEmojiDisplayView.h
//  IMChat
//
//  Created by 李伯坤 on 16/3/16.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMExpressionModel.h"

@interface IMEmojiDisplayView : UIImageView

@property (nonatomic, strong) IMExpressionModel *emoji;

@property (nonatomic, assign) CGRect rect;

- (void)displayEmoji:(IMExpressionModel *)emoji atRect:(CGRect)rect;

@end
