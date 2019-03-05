//
//  IMLoginViewController.m
//  MYIMDemo
//
//  Created by admin on 2019/3/5.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "IMLoginViewController.h"


@interface IMLoginViewController ()
//  logo
@property (nonatomic, strong) UILabel     *nameLogo;
// 用户名
@property (nonatomic, strong) UITextField     *userField;
// 密码
@property (nonatomic, strong) UITextField     *passwordField;

@end

@implementation IMLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)im_addSubViews{
     CGFloat systemVersion = [UIDevice currentSystemVersion].doubleValue;
    
    UILabel *titleLabel =  self.view.addLabel(1001)
    .text(@"IMDemo").textColor([UIColor colorTextBlack])
    .textAlignment(NSTextAlignmentCenter)
    .masonry(^(MASConstraintMaker *make){
        make.size.mas_eq
    });
    _nameLogo =  titleLabel;
}

@end
