//
//  IMNewContactTableViewCell.m
//  MYIMDemo
//
//  Created by admin on 2019/3/13.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "IMNewContactTableViewCell.h"

@implementation IMNewContactTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIStackView *stackView = [[UIStackView alloc] init];
        stackView.distribution = UIStackViewDistributionFillEqually;
        stackView.spacing = 4;
        
        self.agreeBut = [self button:@"同意" textColor:[UIColor colorGreenDefault]];
        [self.agreeBut addTarget:self action:@selector(agreeButAction:) forControlEvents:UIControlEventTouchUpInside];
        self.rejectBut = [self button:@"拒绝" textColor:[UIColor colorRedForButton]];
        [self.rejectBut addTarget:self action:@selector(rejectButAction:) forControlEvents:UIControlEventTouchUpInside];
        self.statusBut = [self button:@"已添加" textColor:[UIColor colorTextlightGrayColor]];
        self.statusBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [stackView addArrangedSubview:self.agreeBut];
        [stackView addArrangedSubview:self.rejectBut];
        [stackView addArrangedSubview:self.statusBut];
        
        [self.contentView addSubview:stackView];
        stackView.sd_layout.widthIs(120).heightIs(44).centerYEqualToView(self.contentView).rightSpaceToView(self.contentView, 10);
    }
    return self;
}

- (UIButton *)button:(NSString *)title textColor:(UIColor *)color{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontNavBarTitle];
    return button;
}

- (void)setDelegate:(id<IMNewContactTableViewCellDelegate>)delegate{
    //  节约内存
    if (_delegate == nil) _delegate = delegate;;
}

- (void)setUser:(IMUser *)user{
    [super setUser:user];
    if ([user.ask isEqualToString:@"subscribe"]) {
        if ([user.subscription isEqualToString:@"both"] || [user.subscription isEqualToString:@"from"]) {
            [self.statusBut setTitle:@"已添加" forState:UIControlStateNormal];
            self.statusBut.hidden = NO;
            self.agreeBut.hidden = YES;
            self.rejectBut.hidden = YES;
        } else if ([user.subscription isEqualToString:@"none"]){
            [self.statusBut setTitle:@"已请求" forState:UIControlStateNormal];
            self.statusBut.hidden = NO;
            self.agreeBut.hidden = YES;
            self.rejectBut.hidden = YES;
        }
        else if ([user.subscription isEqualToString:@"to"]){
            [self.statusBut setTitle:@"已接受" forState:UIControlStateNormal];
            self.statusBut.hidden = NO;
            self.agreeBut.hidden = YES;
            self.rejectBut.hidden = YES;
        }else{
            self.statusBut.hidden = YES;
            self.agreeBut.hidden = YES;
            self.rejectBut.hidden = YES;
        }
    }
}

//  同意按钮
- (void)agreeButAction:(id)sender{
    if (!self.user) return;
    if (self.delegate && [self.delegate respondsToSelector:@selector(newContactTableViewCell:agreeButDidTouchUp:   )]) {
        [[self delegate] newContactTableViewCell:self agreeButDidTouchUp:self.user];
    }
}

//  拒绝按钮
- (void)rejectButAction:(id)sender{
    if (!self.user) return;
    if (self.delegate && [self.delegate respondsToSelector:@selector(newContactTableViewCell:rejectButDidTouchUp:)]) {
        [[self delegate] newContactTableViewCell:self rejectButDidTouchUp:self.user];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
