//
//  IMSettingItemBaseCell.m
//  IMChat
//
//  Created by 徐世杰 on 2018/3/6.
//  Copyright © 2018年 徐世杰. All rights reserved.
//

#import "IMSettingItemBaseCell.h"

@implementation IMSettingItemBaseCell

#pragma mark - # Protocol
+ (CGFloat)viewHeightByDataModel:(id)dataModel
{
    return 44.0f;
}

- (void)setViewDataModel:(id)dataModel
{
    [self setItem:dataModel];
}

- (void)viewIndexPath:(NSIndexPath *)indexPath sectionItemCount:(NSInteger)count
{
    if (indexPath.row == 0) {
        self.addSeparator(IMSeparatorPositionTop);
    }
    else {
        self.removeSeparator(IMSeparatorPositionTop);
    }
    if (indexPath.row == count - 1) {
        self.addSeparator(IMSeparatorPositionBottom);
    }
    else {
        self.addSeparator(IMSeparatorPositionBottom).beginAt(15);
    }
}

#pragma mark - # Cell
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        // 箭头
        self.arrowView = [[UIImageView alloc] initWithImage:IMImage(@"right_arrow")];
        [self addSubview:self.arrowView];
        [self.arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(8, 13));
            make.right.mas_equalTo(-15);
        }];
    }
    return self;
}

- (void)setItem:(IMSettingItem *)item
{
    _item = item;
    
    [self setSelectedBackgrounColor:item.disableHighlight ? nil : [UIColor colorGrayLine]];
    [self.arrowView setHidden:!item.showDisclosureIndicator];
}

@end
