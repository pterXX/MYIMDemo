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
        self.rejectBut = [self button:@"拒绝" textColor:[UIColor colorRedForButton]];
        self.statusBut = [self button:@"已接收" textColor:[UIColor colorTextlightGrayColor]];
        [self.statusBut setTitle:@"已拒绝" forState:UIControlStateSelected];
        [self.statusBut setTitleColor:[UIColor colorTextlightGrayColor] forState:UIControlStateSelected];
        [stackView addArrangedSubview:self.agreeBut];
        [stackView addArrangedSubview:self.rejectBut];
        [stackView addArrangedSubview:self.statusBut];
        
        [self.contentView addSubview:stackView];
        stackView.sd_layout.widthIs(150).heightIs(44).centerYEqualToView(self.contentView).rightSpaceToView(self.contentView, 10);
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


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
