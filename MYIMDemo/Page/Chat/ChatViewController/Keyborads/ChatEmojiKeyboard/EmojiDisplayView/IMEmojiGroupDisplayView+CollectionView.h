//
//  IMEmojiGroupDisplayView+CollectionView.h
//  IMChat
//
//  Created by 李伯坤 on 16/9/27.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "IMEmojiGroupDisplayView.h"

@interface IMEmojiGroupDisplayView (CollectionView) <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

- (void)registerCellClass;


- (NSUInteger)transformModelByRowCount:(NSInteger)rowCount colCount:(NSInteger)colCount andIndex:(NSInteger)index;

@end
