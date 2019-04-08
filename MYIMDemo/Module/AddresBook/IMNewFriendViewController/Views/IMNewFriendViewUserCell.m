//
//  IMNewFriendViewUserCell.m
//  MYIMDemo
//
//  Created by admin on 2019/3/15.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "IMNewFriendViewUserCell.h"

IMNewFriendItem *createNewFriendItemModel(NSString *path, NSString *_Nullable url, NSString *title,  NSString * _Nullable subTitle, id _Nullable userInfo)
{
    return createNewFriendItemModelWithTag(0, path, url, title, subTitle, userInfo);
}

IMNewFriendItem *createNewFriendItemModelWithTag(NSInteger tag, NSString *path, NSString *_Nullable url, NSString *title, NSString *_Nullable subTitle, id _Nullable userInfo)
{
    IMNewFriendItem *model = [[IMNewFriendItem alloc] init];
    model.tag = tag;
    model.imagePath = path;
    model.imageUrl = url;
    model.title = title;
    model.subTitle = subTitle;
    model.userInfo = userInfo;
    return model;
}


@interface IMNewFriendViewUserCell()
@property (nonatomic, strong) UIImageView *avatarView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) UIButton       *agreeBut;        /**< 同意按钮 */
@property (nonatomic, strong) UIButton       *rejectBut;       /**< 拒绝按钮 */
@property (nonatomic, strong) UIButton       *statusBut;       /**< 状态按钮 */

@end

@implementation IMNewFriendViewUserCell

#pragma mark - # Cell


+ (CGFloat)viewHeightByDataModel:(id)dataModel
{
    return 55.0f;
}

- (void)setViewDataModel:(id)dataModel
{
    [self setModel:dataModel];
}

- (void)setViewDelegate:(id)delegate{
    [self setDelegate:delegate];
}

- (void)viewIndexPath:(NSIndexPath *)indexPath sectionItemCount:(NSInteger)count
{
    if (indexPath.row == count - 1) {
        self.removeSeparator(IMSeparatorPositionBottom);
    }
    else {
        self.addSeparator(IMSeparatorPositionBottom).beginAt(10);
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self p_initUI];
    }
    return self;
}

- (void)setModel:(IMNewFriendItem *)model
{
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
    
    //  同意按钮
    self.agreeBut = [self button:@"同意" textColor:[UIColor colorGreenDefault]];
    [self.agreeBut addTarget:self action:@selector(agreeButAction:) forControlEvents:UIControlEventTouchUpInside];
    //  拒绝按钮
    self.rejectBut = [self button:@"拒绝" textColor:[UIColor colorRedForButton]];
    [self.rejectBut addTarget:self action:@selector(rejectButAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //  状态按钮
    self.statusBut = [self button:@"已添加" textColor:[UIColor colorTextlightGrayColor]];
    self.statusBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.statusBut.hidden = YES;
    
    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.distribution = UIStackViewDistributionFillEqually;
    stackView.spacing = 4;
    
    [stackView addArrangedSubview:self.agreeBut];
    [stackView addArrangedSubview:self.rejectBut];
    [stackView addArrangedSubview:self.statusBut];
    
    [self.contentView addSubview:stackView];
    [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(44);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(self.contentView).mas_offset(-10);
    }];
}

- (UIButton *)button:(NSString *)title textColor:(UIColor *)color{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontNavBarTitle];
    return button;
}

- (void)setDelegate:(id<IMNewFriendCellDelegate>)delegate{
    //  节约内存
    if (_delegate == nil) _delegate = delegate;;
}


//  同意按钮
- (void)agreeButAction:(id)sender{
    if (!self.model.userInfo && ![self.model.userInfo isKindOfClass:[IMUser class]]) return;
    if (self.delegate && [self.delegate respondsToSelector:@selector(newFriendCell:agreeButDidTouchUp:)]) {
        [[self delegate] newFriendCell:self agreeButDidTouchUp:self.model.userInfo];
    }
}

//  拒绝按钮
- (void)rejectButAction:(id)sender{
    if (!self.model.userInfo && ![self.model.userInfo isKindOfClass:[IMUser class]]) return;
    if (self.delegate && [self.delegate respondsToSelector:@selector(newFriendCell:rejectButDidTouchUp:)]) {
        [[self delegate] newFriendCell:self rejectButDidTouchUp:self.self.model.userInfo];
    }
}


@end


@implementation IMNewFriendItem

@end
