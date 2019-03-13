//
//  IMAddressBookTableViewCell.m
//  MYIMDemo
//
//  Created by admin on 2019/3/11.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "IMAddressBookTableViewCell.h"

@implementation IMAddressBookTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    
    _avaterImageView                   = [UIImageView new];
    _avaterImageView.backgroundColor   = [UIColor groupTableViewBackgroundColor];
    CGFloat cellLayoutHeight           = [[self class] cellLayoutHeight];
    CGRect rect                        = CGRectMake(0, 0, cellLayoutHeight - 10, cellLayoutHeight - 10);
    [self addSubview:_avaterImageView];
    //  绘制圆角
    layoutRoundCorner(_avaterImageView, rect, 5);
    
    _avaterImageView.sd_layout.topSpaceToView(self, 5).leftSpaceToView(self, 10).widthIs(rect.size.height).heightEqualToWidth();
    
    _titleLabel                        = [UILabel new];
    _titleLabel.font                   = [UIFont systemFontOfSize:16];
    _titleLabel.textColor              = [UIColor blackColor];
    [self addSubview:_titleLabel];
    _titleLabel.sd_layout.leftSpaceToView(_avaterImageView, 10).rightSpaceToView(self,10).topEqualToView(_avaterImageView).heightIs(rect.size.height);
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

+ (CGFloat)cellLayoutHeight{
    return 50;
}
@end
