//
//  IMExpressionGroupModel+IMEmojiKB.m
//  IMChat
//
//  Created by 李伯坤 on 2018/1/2.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import "IMExpressionGroupModel+IMEmojiKB.h"

@implementation IMExpressionGroupModel (IMEmojiKB)

- (NSUInteger)rowNumber
{
    if (self.type == IMEmojiTypeFace || self.type == IMEmojiTypeEmoji) {
        return 3;
    }
    return 2;
}

- (NSUInteger)colNumber
{
    if (self.type == IMEmojiTypeFace || self.type == IMEmojiTypeEmoji) {
        return 7;
    }
    return 4;
}

- (NSUInteger)pageItemCount
{
    if (self.type == IMEmojiTypeFace || self.type == IMEmojiTypeEmoji) {
        return self.rowNumber * self.colNumber - 1;
    }
    return self.rowNumber * self.colNumber;
}

- (NSUInteger)pageNumber
{
    return self.count / self.pageItemCount + (self.count % self.pageItemCount == 0 ? 0 : 1);
}

@end
