//
//  IMNewFriendViewUserCell.h
//  MYIMDemo
//
//  Created by admin on 2019/3/15.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "IMBaseTableViewCell.h"
#import "IMFlexibleLayoutViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class IMNewFriendItem;
@class IMNewFriendViewUserCell;

@protocol IMNewFriendCellDelegate <NSObject>

-(void)newFriendCell:(IMNewFriendViewUserCell *)cell agreeButDidTouchUp:(IMUser *)user;

-(void)newFriendCell:(IMNewFriendViewUserCell *)cell rejectButDidTouchUp:(IMUser *)user;

@end

IMNewFriendItem *createNewFriendItemModel(NSString *path, NSString *_Nullable url, NSString *title,  NSString * _Nullable subTitle, id _Nullable userInfo);
IMNewFriendItem *createNewFriendItemModelWithTag(NSInteger tag, NSString *path, NSString *_Nullable url, NSString *title, NSString *_Nullable subTitle, id _Nullable userInfo);

@interface IMNewFriendItem : NSObject
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
@interface IMNewFriendViewUserCell : IMBaseTableViewCell<IMFlexibleLayoutViewProtocol>
@property (nonatomic, strong) IMNewFriendItem *model;
@property (nonatomic, weak) id<IMNewFriendCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
