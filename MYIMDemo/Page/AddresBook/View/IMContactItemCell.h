//
//  IMContactItemCell.h
//  MYIMDemo
//
//  Created by admin on 2019/3/15.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "IMBaseTableViewCell.h"
#import "IMFlexibleLayoutViewProtocol.h"
#import "IMUserGroup.h"
NS_ASSUME_NONNULL_BEGIN
@class IMContactsItem;

IMContactsItem *createContactsItemModel(NSString *path, NSString *_Nullable url, NSString *title,  NSString * _Nullable subTitle, id _Nullable userInfo);
IMContactsItem *createContactsItemModelWithTag(NSInteger tag, NSString *path, NSString *_Nullable url, NSString *title, NSString *_Nullable subTitle, id _Nullable userInfo);

@interface IMContactsItem : NSObject
/// tag
@property (nonatomic, assign) NSInteger tag;

/// 图片本地路径
@property (nonatomic, strong) NSString *imagePath;

/// 图片url，优先使用
@property (nonatomic, strong) NSString *imageUrl;

/// 标题
@property (nonatomic, strong) NSString *title;

/// 副标题
@property (nonatomic, strong) NSString *subTitle;

/// 占位图
@property (nonatomic, strong) UIImage *placeholderImage;

/// 用户自定义数据
@property (nonatomic, strong) id userInfo;

@end


@interface IMContactItemCell : IMBaseTableViewCell <IMFlexibleLayoutViewProtocol>
@property (nonatomic, strong) IMContactsItem *model;
@end

NS_ASSUME_NONNULL_END
