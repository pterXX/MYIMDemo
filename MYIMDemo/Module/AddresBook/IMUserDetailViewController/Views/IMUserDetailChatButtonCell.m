//
//  IMUserDetailButtonCell.m
//  IMChat
//
//  Created by 徐世杰 on 2018/1/7.
//  Copyright © 2018年 徐世杰. All rights reserved.
//

#import "IMUserDetailChatButtonCell.h"

@interface IMUserDetailChatButtonCell ()

@property (nonatomic, copy) id (^eventAction)(NSInteger, id);

@end

@implementation IMUserDetailChatButtonCell

+ (CGFloat)viewHeightByDataModel:(id)dataModel
{
    return 62.0f;
}

- (void)setViewDataModel:(id)dataModel
{
    [self.button setTitle:dataModel forState:UIControlStateNormal];
}

- (void)setViewEventAction:(id (^)(NSInteger, id))eventAction
{
    self.eventAction = eventAction;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        @weakify(self);
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button.backgroundColor = [UIColor colorGreenDefault];
        [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.button.layer.cornerRadius = 5;
        self.button.layer.masksToBounds = YES;
        self.button.layer.borderColor = [UIColor colorGrayLine].CGColor;
        self.button.layer.borderWidth = IMBORDER_WIDTH_1PX;
        [self.contentView addSubview:self.button];
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(-15);
        }];
        
        [self.button addIMClickAction:^(UIButton *button){
            @strongify(self);
            if (self.eventAction) {
                self.eventAction(0, nil);
            }
        }];
    }
    return self;
}

@end
