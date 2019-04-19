//
//  BehaviorTimeCell.h
//  Demo
//
//  Created by admin on 2019/4/18.
//  Copyright © 2019 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface BehaviorTimeCell : UITableViewCell
@property (nonatomic ,strong) UIView     *bgView;

@property (nonatomic ,strong) id model;
//  聊天按钮的回调
@property (nonatomic ,strong) void(^chatBtnPressBlock)(id model);
//  cell的高度
+ (CGFloat)viewHeightByDataModel:(id)dataModel;

@end

NS_ASSUME_NONNULL_END
