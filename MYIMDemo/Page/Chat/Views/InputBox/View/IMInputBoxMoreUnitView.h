//
//  IMInputBoxMoreUnitView.h
//  KXiniuCloud
//
//  Created by eims on 2018/5/10.
//  Copyright © 2018年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IMInputBoxMoreModel;

@interface IMInputBoxMoreUnitView : UIControl

// 框
@property (nonatomic, strong) UIView *box;
// 图标
@property (nonatomic, strong) UIImageView *imageView;
// 文字
@property (nonatomic, strong) UILabel     *titleLabel;

@property (nonatomic, strong) IMInputBoxMoreModel *moreModel;

@end
