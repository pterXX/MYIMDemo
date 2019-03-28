//
//  UIView+IMFLEX.m
//  zhuanzhuan
//
//  Created by 李伯坤 on 2017/10/24.
//  Copyright © 2017年 转转. All rights reserved.
//

#import "UIView+IMFLEX.h"

#define IMFLEX_VE_API(methodName, IMChainModelClass, UIViewClass) \
- (IMChainModelClass * (^)(NSInteger tag))methodName    \
{   \
    return ^IMChainModelClass* (NSInteger tag) {      \
        UIViewClass *view = [[UIViewClass alloc] init];       \
        [self addSubview:view];                            \
        IMChainModelClass *chainModel = [[IMChainModelClass alloc] initWithTag:tag andView:view]; \
        return chainModel;      \
    };      \
}

@implementation UIView (IMFLEX)

IMFLEX_VE_API(addView, IMViewChainModel, UIView);
IMFLEX_VE_API(addLabel, IMLabelChainModel, UILabel);
IMFLEX_VE_API(addImageView, IMImageViewChainModel, UIImageView);

#pragma mark - # 按钮类
IMFLEX_VE_API(addControl, IMControlChainModel, UIControl);
IMFLEX_VE_API(addTextField, IMTextFieldChainModel, UITextField);
IMFLEX_VE_API(addButton, IMButtonChainModel, UIButton);
IMFLEX_VE_API(addSwitch, IMSwitchChainModel, UISwitch);

#pragma mark - # 滚动视图类
IMFLEX_VE_API(addScrollView, IMScrollViewChainModel, UIScrollView);
IMFLEX_VE_API(addTextView, IMTextViewChainModel, UITextView);
IMFLEX_VE_API(addTableView, IMTableViewChainModel, UITableView);

- (IMCollectionViewChainModel * (^)(NSInteger tag))addCollectionView
{
    return ^IMCollectionViewChainModel* (NSInteger tag) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = layout.minimumLineSpacing = 0;
        layout.headerReferenceSize = layout.footerReferenceSize = CGSizeZero;
        layout.sectionInset = UIEdgeInsetsZero;
        UICollectionView *view = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [self addSubview:view];
        IMCollectionViewChainModel *chainModel = [[IMCollectionViewChainModel alloc] initWithTag:tag andView:view];
        return chainModel;
    };
}

@end
