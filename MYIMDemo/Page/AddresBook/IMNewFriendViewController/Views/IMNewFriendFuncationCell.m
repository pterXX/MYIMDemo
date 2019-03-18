//
//  IMNewFriendFuncationCell.m
//  MYIMDemo
//
//  Created by admin on 2019/3/15.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "IMNewFriendFuncationCell.h"

IMNewFriendFuncationModel *createNewFriendFuncationModel(NSString *icon, NSString *title)
{
    IMNewFriendFuncationModel *model = [[IMNewFriendFuncationModel alloc] init];
    model.iconPath = icon;
    model.title = title;
    return model;
}

@interface IMNewFriendFuncationCell ()

@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation IMNewFriendFuncationCell

+ (CGFloat)viewHeightByDataModel:(id)dataModel
{
    return 80;
}

- (void)setViewDataModel:(id)dataModel
{
    [self setModel:dataModel];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [self p_initUI];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    self.addSeparator(SeparatorPositionBottom).borderWidth(1);
}

- (void)setModel:(IMNewFriendFuncationModel *)model
{
    _model = model;
    [self.iconView setImage:IMImage(model.iconPath)];
    [self.nameLabel setText:model.title];
}

#pragma mark - # Private Methods
- (void)p_initUI
{
    self.iconView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.iconView];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(36);
    }];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont systemFontOfSize:12];
    self.nameLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-10);
        make.centerX.mas_equalTo(0);
        make.width.mas_lessThanOrEqualTo(self.contentView).mas_offset(-30);
    }];
}

@end

@implementation IMNewFriendFuncationModel

@end
