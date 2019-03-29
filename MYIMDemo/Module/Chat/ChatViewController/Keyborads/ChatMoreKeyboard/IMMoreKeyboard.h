//
//  IMMoreKeyboard.h
//  IMChat
//
//  Created by 徐世杰 on 16/2/17.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "IMBaseKeyboard.h"
#import "IMKeyboardDelegate.h"
#import "IMMoreKeyboardDelegate.h"
#import "IMMoreKeyboardItem.h"

@interface IMMoreKeyboard : IMBaseKeyboard

@property (nonatomic, assign) id<IMMoreKeyboardDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *chatMoreKeyboardData;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIPageControl *pageControl;

+ (IMMoreKeyboard *)keyboard;

@end
