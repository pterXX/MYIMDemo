//
//  IMExpressionGroupModel+IMEmojiKB.h
//  IMChat
//
//  Created by 李伯坤 on 2018/1/2.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import "IMExpressionGroupModel.h"

@interface IMExpressionGroupModel (IMEmojiKB)


/// 每页个数
@property (nonatomic, assign, readonly) NSUInteger pageItemCount;

/// 页数
@property (nonatomic, assign, readonly) NSUInteger pageNumber;

/// 行数
@property (nonatomic, assign, readonly) NSUInteger rowNumber;

/// 列数
@property (nonatomic, assign, readonly) NSUInteger colNumber;

@end
