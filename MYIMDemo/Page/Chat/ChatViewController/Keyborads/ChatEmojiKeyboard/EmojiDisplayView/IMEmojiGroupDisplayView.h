//
//  IMEmojiGroupDisplayView.h
//  IMChat
//
//  Created by 李伯坤 on 16/9/27.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMEmojiGroupDisplayViewDelegate.h"
#import "IMEmojiGroupDisplayModel.h"

@interface IMEmojiGroupDisplayView : UIView

@property (nonatomic, weak) id<IMEmojiGroupDisplayViewDelegate> delegate;

@property (nonatomic, weak) NSMutableArray *data;

@property (nonatomic, strong) NSMutableArray *displayData;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) NSInteger curPageIndex;

- (void)scrollToEmojiGroupAtIndex:(NSInteger)index;

@end
