//
//  IMMoreKeyboard+CollectionView.h
//  IMChat
//
//  Created by 徐世杰 on 16/3/17.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "IMMoreKeyboard.h"

@interface IMMoreKeyboard (CollectionView) <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign, readonly) NSInteger pageItemCount;

- (void)registerCellClass;

@end
