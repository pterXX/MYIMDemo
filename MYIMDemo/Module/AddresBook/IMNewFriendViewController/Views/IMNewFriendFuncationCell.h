//
//  IMNewFriendFuncationCell.h
//  MYIMDemo
//
//  Created by admin on 2019/3/15.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "IMBaseTableViewCell.h"
#import "IMFlexibleLayoutViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class IMNewFriendFuncationModel;
IMNewFriendFuncationModel *createNewFriendFuncationModel(NSString *icon, NSString *title);

@interface IMNewFriendFuncationModel : NSObject

/// 图片
@property (nonatomic, strong) NSString *iconPath;

/// 标题
@property (nonatomic, strong) NSString *title;

@end

@interface IMNewFriendFuncationCell : IMBaseTableViewCell <IMFlexibleLayoutViewProtocol>

/// 模型
@property (nonatomic, strong) IMNewFriendFuncationModel *model;

@end

NS_ASSUME_NONNULL_END
