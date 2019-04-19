//
//  BehaviorItemCell.h
//  Demo
//
//  Created by admin on 2019/4/18.
//  Copyright © 2019 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class BehaviorItem;

typedef void(^BehaviorActionBlock)(BehaviorItem *item);

BehaviorItem *createBehaviorItemModel(NSString *path, NSString *_Nullable url, NSString *title,  NSString * _Nullable subTitle, id _Nullable userInfo,BehaviorActionBlock action);

BehaviorItem *createBehaviorItemModelWithTag(NSInteger tag, NSString *path, NSString *_Nullable url, NSString *title, NSString *_Nullable subTitle, id _Nullable userInfo,BehaviorActionBlock action);

@interface BehaviorItem : NSObject
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

///  点击后的操作
@property (nonatomic, copy) BehaviorActionBlock actionBlock;
@end

@interface BehaviorItemCell : UITableViewCell
@property (nonatomic ,strong) BehaviorItem *model;

//  cell的高度
+ (CGFloat)viewHeightByDataModel:(id)dataModel;
@end

NS_ASSUME_NONNULL_END
