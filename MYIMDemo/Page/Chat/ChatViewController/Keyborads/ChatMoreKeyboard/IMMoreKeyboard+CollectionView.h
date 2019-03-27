//
//  IMMoreKeyboard+CollectionView.h
//  IMChat
//
//  Created by 李伯坤 on 16/3/17.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "IMMoreKeyboard.h"

@interface IMMoreKeyboard (CollectionView) <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign, readonly) NSInteger pageItemCount;

- (void)registerCellClass;

@end
