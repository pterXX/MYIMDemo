//
//  BehaviorTimeCell.m
//  Demo
//
//  Created by admin on 2019/4/18.
//  Copyright © 2019 admin. All rights reserved.
//

#import "BehaviorTimeCell.h"


@interface BehaviorTimeCell()

@property (nonatomic, strong) UIButton   *chatBtn;
@property (nonatomic, strong) UIImageView *avatarView, *timeImage;
@property (nonatomic, strong) UILabel *nameLabel,*subTitleLabel,*timeLabel;
@end

@implementation BehaviorTimeCell

//  cell的高度
+ (CGFloat)viewHeightByDataModel:(id)dataModel
{
    return 115.0f;
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
    [self.contentView setBackgroundColor:UIColorFromRGB(0xf6f6f6)];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    // 背景
    self.bgView = [UIView new];
    [self.bgView setBackgroundColor:[UIColor whiteColor]];
    self.bgView.layer.cornerRadius = 4;
    [self.contentView addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(7.5, 12, 7.5, 12));
    }];
    
    //  时间图片
    self.timeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"time_icon_24"]];
    [self.bgView addSubview:self.timeImage];
    [self.timeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(12);
        make.height.equalTo(self.timeImage.mas_width);
        make.top.mas_equalTo(18);
        make.left.mas_equalTo(15);
    }];
    
    //  时间
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.textColor = PROJECT_GREENCOLOR;
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    [self.bgView addSubview: self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.timeImage.mas_centerY);
        make.left.equalTo(self.timeImage.mas_right).offset(8);
        make.width.mas_equalTo(150);
    }];
    
    //  聊天按钮
    self.chatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.chatBtn setBackgroundImage:[UIImage imageNamed:@"consult_icon_64"] forState:UIControlStateNormal];
    [self.chatBtn addTarget:self action:@selector(chatBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.chatBtn];
    [self.chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(32, 32));
        make.top.mas_equalTo(12);
        make.right.mas_equalTo(-15);
    }];
    
    CGRect bounds = CGRectMake(0, 0, 36, 36);
    // 头像
    self.avatarView = [[UIImageView alloc] init];
    self.avatarView.backgroundColor = UIColorFromRGB(0xf6f6f6);
    // 绘制圆角 layer.cornerRadius 浪费性能
    [self p_layoutCorners:bounds cornerRadii:bounds.size view:self.avatarView];
    [self.bgView addSubview:self.avatarView];
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.timeLabel.mas_left);
        make.bottom.mas_equalTo(-15);
        make.height.mas_equalTo(bounds.size.height);
        make.width.mas_equalTo(self.avatarView.mas_height);
    }];
    
    // 昵称
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    self.nameLabel.textColor = UIColorFromRGB(0x333333);
    [self.bgView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatarView.mas_right).mas_offset(10);
        make.top.mas_equalTo(self.avatarView.mas_top);
        make.right.mas_equalTo(-15);
    }];
    
    // 备注
    self.subTitleLabel = [[UILabel alloc] init];
    self.subTitleLabel.font = [UIFont systemFontOfSize:15];
    self.subTitleLabel.textColor = UIColorFromRGB(0x333333);
    [self.bgView addSubview:self.subTitleLabel];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.bottom.mas_equalTo(self.avatarView.mas_bottom);
        make.right.mas_equalTo(-15);
    }];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

//  绘制圆角
- (void)p_layoutCorners:(CGRect)bounds cornerRadii:(CGSize)cornerRadii view:(UIImageView *)view{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = bounds;   //设置大小
    maskLayer.path = maskPath.CGPath; //设置图形样子
    view.layer.mask = maskLayer;
}

#pragma mark - # Events Methods
//  聊天按钮点击
- (void)chatBtnPress:(UIButton *)sender{
    //  使用block将数据回调给控制器
    if (self.chatBtnPressBlock) {
        self.chatBtnPressBlock(self.model);  //  聊天按钮点击
    }
}

//  赋值数据
- (void)setModel:(id)model{
    _model = model;
    _timeLabel.text = @"2019.03.28 16.08";
    _nameLabel.text = @"今尚古";
    _avatarView.image = [UIImage imageNamed:@"view_site_icon_72"];
    
    NSInteger count = 2;
    NSString *str = [NSString stringWithFormat:@"第%@次",@(count)];
    NSString *type = @"工地";
    NSString *content = [NSString stringWithFormat:@"%@查看%@,你成功x的吸引了TA",str,type];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:content];
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, content.length)];
    [attr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x333333) range:NSMakeRange(0, content.length)];
    [attr addAttribute:NSForegroundColorAttributeName value:PROJECT_GREENCOLOR range:[content rangeOfString:str]];
    [attr addAttribute:NSForegroundColorAttributeName value:PROJECT_GREENCOLOR range:[content rangeOfString:type]];
    _subTitleLabel.attributedText = attr;
}

@end
