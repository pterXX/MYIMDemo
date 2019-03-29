//
//  IMEmojiBaseCell.h
//  IMChat
//
//  Created by 徐世杰 on 16/3/9.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMExpressionModel.h"

@protocol IMEmojiCellProtocol <NSObject>

- (CGRect)displayBaseRect;

@end

@interface IMEmojiBaseCell : UICollectionViewCell <IMEmojiCellProtocol>

@property (nonatomic, strong) IMExpressionModel *emojiItem;

@property (nonatomic, strong) UIImageView *bgView;

/**
 *  选中时的背景图片，默认nil
 */
@property (nonatomic, strong) UIImage *highlightImage;

@property (nonatomic, assign) BOOL showHighlightImage;

@end
