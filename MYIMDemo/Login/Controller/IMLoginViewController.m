//
//  IMLoginViewController.m
//  MYIMDemo
//
//  Created by admin on 2019/3/5.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "IMLoginViewController.h"


@interface IMLoginViewController ()
@property (nonatomic, strong) UILabel     *nameLogo;//  logo
@property (nonatomic, strong) UITextField *userField;// 用户名
@property (nonatomic, strong) UITextField *passwordField;// 密码
@property (nonatomic, strong) UIButton     *signInBtn;// 登录按钮
@end

#define kTextFieldSize CGSizeMake(325,44);

@implementation IMLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)im_addSubViews{
    //     CGFloat systemVersion = [UIDevice currentSystemVersion].doubleValue;
     kWeakSelf;
    //  背景
    self.view.addImageView(1000)
    .image([UIImage imageLoginBackground])
    .contentMode(UIViewContentModeScaleAspectFit);
    
    // logo
    self.nameLogo =  self.view.addLabel(1001)
    .text(@"IMDemo").textColor([UIColor colorTextBlack])
    .textAlignment(NSTextAlignmentCenter)
    .font([UIFont fontLoginLogo])
    .masonry(^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 50));
        make.top.mas_offset(IMNAVBAR_HEIGHT);
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
    }).view;
    
    CGSize textFieldSize =  kTextFieldSize;
    //  账号
    self.userField = [self addTextField:@"账号" placeholder:@"请输入账号" tag:1002];
    self.userField.zz_make.masonry(^(MASConstraintMaker *make) {
        make.size.mas_equalTo(textFieldSize);
        make.top.mas_equalTo(weakSelf.view.mas_bottom).mas_offset(40);
        make.centerX.mas_equalTo(weakSelf.nameLogo.mas_centerX);
    });
    
    // 密码
    self.passwordField = [self addTextField:@"账号" placeholder:@"请输入账号" tag:1003];
    self.passwordField.zz_make.masonry(^(MASConstraintMaker *make) {
        make.size.mas_equalTo(weakSelf.userField);
        make.top.mas_equalTo(weakSelf.userField.mas_bottom).mas_offset(10);
        make.centerX.mas_equalTo(weakSelf.nameLogo.mas_centerX);
    });
    
    self.signInBtn = self.view.addButton(1004)
    .title(@"登录").titleColor([UIColor colorTextBlack])
    .cornerRadius(textFieldSize.height * 0.5)
    .border(IMBORDER_WIDTH_1PX, [UIColor whiteColor])
    .masksToBounds(YES)
    .backgroundColor([UIColor whiteColor])
    .masonry(^(MASConstraintMaker *make) {
        make.size.mas_equalTo(weakSelf.userField);
        make.top.mas_equalTo(weakSelf.passwordField.mas_bottom).mas_offset(10);
        make.centerX.mas_equalTo(weakSelf.nameLogo.mas_centerX);
    })
    // 设置事件
    .eventBlock(UIControlEventTouchDown, ^(UIButton *sender){
        sender.enabled = NO;
        sender.alpha = 0.5f;
    })
    .eventBlock(UIControlEventTouchUpInside, ^(UIButton *sender){
        sender.enabled = YES;
        sender.alpha = 1.0f;
    }).view;
    
}

- (UITextField *)addTextField:(NSString *)title placeholder:(NSString *)placeholder tag:(NSInteger)tag
{
    UILabel *label = UILabel.zz_create(tag * 10 + 1)
    .text(title).textColor([UIColor whiteColor])
    .textAlignment(NSTextAlignmentCenter)
    .font([UIFont fontLoginUserAndPassword]).view;
    
    CGSize textFieldSize =  kTextFieldSize;
    UITextField *textFiled =  UITextField.zz_create(tag)
    .font([UIFont fontLoginUserAndPassword])
    .textColor([UIColor whiteColor])
    .leftView(label)
    .placeholder(placeholder)
    .cornerRadius(textFieldSize.height * 0.5)
    .border(IMBORDER_WIDTH_1PX,[UIColor whiteColor])
    .masksToBounds(YES).view;
    return textFiled;
}
@end
