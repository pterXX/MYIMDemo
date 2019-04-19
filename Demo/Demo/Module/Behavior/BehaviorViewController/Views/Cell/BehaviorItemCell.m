//
//  BehaviorItemCell.m
//  Demo
//
//  Created by admin on 2019/4/18.
//  Copyright © 2019 admin. All rights reserved.
//

#import "BehaviorItemCell.h"
#import <Masonry/Masonry.h>


BehaviorItem *createBehaviorItemModel(NSString *path, NSString *_Nullable url, NSString *title,  NSString * _Nullable subTitle, id _Nullable userInfo,BehaviorActionBlock action)
{
    return createBehaviorItemModelWithTag(0, path, url, title, subTitle, userInfo,action);
}

BehaviorItem *createBehaviorItemModelWithTag(NSInteger tag, NSString *path, NSString *_Nullable url, NSString *title, NSString *_Nullable subTitle, id _Nullable userInfo,BehaviorActionBlock action)
{
    BehaviorItem *model = [[BehaviorItem alloc] init];
    model.tag = tag;
    model.imagePath = path;
    model.imageUrl = url;
    model.title = title;
    model.subTitle = subTitle;
    model.userInfo = userInfo;
    model.actionBlock = action;
    return model;
}

@implementation BehaviorItem

@end

@interface BehaviorItemCell()
@property (nonatomic, strong) UIImageView *avatarView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *subTitleLabel;
@end

@implementation BehaviorItemCell

#pragma mark - # Cell


+ (CGFloat)viewHeightByDataModel:(id)dataModel
{
    return 65.0f;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self p_initUI];
    }
    return self;
}


#pragma mark - # Private Methods
- (void)p_initUI
{
    // 头像
    self.avatarView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.avatarView];
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(14.5);
        make.bottom.mas_equalTo(-14.5);
        make.width.mas_equalTo(self.avatarView.mas_height);
    }];
    
    // 昵称
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    self.nameLabel.textColor = UIColorFromRGB(0x333333);
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatarView.mas_right).mas_offset(12);
        make.centerY.mas_equalTo(self.avatarView);
        make.right.mas_equalTo(50);
    }];
    
    // 备注
    self.subTitleLabel = [[UILabel alloc] init];
    self.subTitleLabel.font = [UIFont systemFontOfSize:15];
    self.subTitleLabel.textColor = UIColorFromRGB(0x333333);
    self.subTitleLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.subTitleLabel];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel);
        make.centerY.mas_equalTo(self.nameLabel);
        make.right.mas_equalTo(0);
    }];
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

//  加载数据
- (void)setModel:(BehaviorItem *)model{
    _model = model;
    
    if (model.imageUrl) {
        [self.avatarView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl]];
    }else{
        self.avatarView.image = [UIImage imageNamed:model.imagePath];
    }
    
    self.nameLabel.text = model.title;
    self.subTitleLabel.text = model.subTitle;
}


@end
