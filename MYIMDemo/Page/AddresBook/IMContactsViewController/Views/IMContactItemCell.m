//
//  IMContactItemCell.m
//  MYIMDemo
//
//  Created by admin on 2019/3/15.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "IMContactItemCell.h"

IMContactsItem *createContactsItemModel(NSString *path, NSString *_Nullable url, NSString *title,  NSString * _Nullable subTitle, id _Nullable userInfo)
{
    return createContactsItemModelWithTag(0, path, url, title, subTitle, userInfo);
}

IMContactsItem *createContactsItemModelWithTag(NSInteger tag, NSString *path, NSString *_Nullable url, NSString *title, NSString *_Nullable subTitle, id _Nullable userInfo)
{
    IMContactsItem *model = [[IMContactsItem alloc] init];
    model.tag = tag;
    model.imagePath = path;
    model.imageUrl = url;
    model.title = title;
    model.subTitle = subTitle;
    model.userInfo = userInfo;
    return model;
}


@interface IMContactItemCell()
@property (nonatomic, strong) UIImageView *avatarView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *subTitleLabel;
@end

@implementation IMContactItemCell

#pragma mark - # Cell


+ (CGFloat)viewHeightByDataModel:(id)dataModel
{
    return 55.0f;
}

- (void)setViewDataModel:(id)dataModel
{
    [self setModel:dataModel];
}

- (void)viewIndexPath:(NSIndexPath *)indexPath sectionItemCount:(NSInteger)count
{
    if (indexPath.row == count - 1) {
        self.removeSeparator(SeparatorPositionBottom);
    }
    else {
        self.addSeparator(SeparatorPositionBottom).beginAt(10);
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self p_initUI];
    }
    return self;
}

- (void)setModel:(IMContactsItem *)model{
    _model = model;
    
    UIImage *localImage = (model.imagePath.length > 0 ? IMImage(model.imagePath) : nil);
    if (model.imageUrl) {
        UIImage *placeholder = model.placeholderImage ? model.placeholderImage : (localImage ? localImage : [UIImage imageDefaultHeadPortrait]);
        [self.avatarView sd_setImageWithURL:IMURL(model.imageUrl) placeholderImage:placeholder];
    }
    else if (model.imagePath) {
        [self.avatarView setImage:IMImage(model.imagePath)];
    }else if ([model.userInfo isKindOfClass:[IMUser class]]) {
        IMUser *user = model.userInfo;
        self.avatarView.image = user.avatar?:[UIImage imageDefaultHeadPortrait];
    }else{
        self.avatarView.image = [UIImage imageDefaultHeadPortrait];
    }
    
    [self.nameLabel setText:model.title];
    [self.subTitleLabel setText:model.subTitle];
    
    if (model.subTitle.length > 0) {
        if (self.subTitleLabel.isHidden) {
            [self.subTitleLabel setHidden:NO];
            [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.avatarView).mas_offset(-9.5);
            }];
        }
    }
    else if (!self.subTitleLabel.isHidden){
        [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.avatarView);
        }];
    }
}

#pragma mark - # Prvate Methods
- (void)p_initUI
{
    // 头像
    self.avatarView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.avatarView];
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
        make.width.mas_equalTo(self.avatarView.mas_height);
    }];
    
    // 昵称
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont fontContactItemName];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatarView.mas_right).mas_offset(10);
        make.centerY.mas_equalTo(self.avatarView);
        make.right.mas_lessThanOrEqualTo(-20);
    }];
    
    // 备注
    self.subTitleLabel = [[UILabel alloc] init];
    self.subTitleLabel.font = [UIFont fontContactItemSubTitle];
    self.subTitleLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.subTitleLabel];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_offset(2);
        make.right.mas_lessThanOrEqualTo(-20);
    }];
}

@end


@implementation IMContactsItem

@end
