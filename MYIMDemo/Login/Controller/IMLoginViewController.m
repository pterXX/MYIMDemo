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
    [self.view addSubview:({
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageLoginBackground]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = self.view.bounds;
        imageView;
    })];
    
    
    // logo
    [self.view addSubview:({
        self.nameLogo = [[UILabel alloc] initWithFrame:CGRectMake((IMSCREEN_WIDTH - 200) * 0.5, IMNAVBAR_HEIGHT + IMSTATUSBAR_HEIGHT, 200, 50)];
        self.nameLogo.text = @"IMDemo";
        self.nameLogo.textAlignment = NSTextAlignmentCenter;
        self.nameLogo.textColor = [UIColor whiteColor];
        self.nameLogo.font = [UIFont fontLoginLogo];
        self.nameLogo;
    })];
    
    CGSize textFieldSize =  kTextFieldSize;
    //  账号
    [self.view addSubview:({
        self.userField = [self addTextField:@"账号" placeholder:@"请输入账号" ];
        self.userField.size = textFieldSize;
        self.userField.x = (self.view.width - self.userField.width) * 0.5;
        self.userField.top = self.nameLogo.bottom + 40;
        self.userField;
    })] ;
    
    // 密码
    [self.view addSubview:({
        self.passwordField = [self addTextField:@"密码" placeholder:@"请输入密码" ];
        self.passwordField.size = textFieldSize;
        self.passwordField.x = self.userField.x;
        self.passwordField.top = self.userField.bottom + 10;
        self.passwordField;
    })];
    
    //  登录按钮
    [self.view addSubview:({
        self.signInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.signInBtn setTitle:@"登录" forState:UIControlStateNormal | UIControlStateSelected | UIControlStateFocused];
        [self.signInBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal | UIControlStateSelected | UIControlStateFocused];
        self.signInBtn.layer.cornerRadius = textFieldSize.height * 0.5;
        self.signInBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        self.signInBtn.layer.borderWidth = IMBORDER_WIDTH_1PX;
        self.signInBtn.layer.masksToBounds = (YES);
        //  点击事件
        [self.signInBtn addIMCallBackAction:^(UIButton *button) {
            button.enabled = NO;
            button.alpha = 0.5f;
        } forControlEvents:UIControlEventTouchDown];
        //  手指提起的事件
        [self.signInBtn addIMCallBackAction:^(UIButton *button) {
            button.enabled = YES;
            button.alpha = 1.0f;
        } forControlEvents:UIControlEventTouchUpInside];
        self.signInBtn;
    })];
    
    
}

- (UITextField *)addTextField:(NSString *)title placeholder:(NSString *)placeholder
{
    CGSize textFieldSize =  kTextFieldSize;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, textFieldSize.height)];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontLoginUserAndPassword];
    label.textColor = [UIColor whiteColor];

    UITextField *textFiled = [[UITextField alloc] init];
    textFiled.font = [UIFont fontLoginUserAndPassword];
    textFiled.textColor = [UIColor whiteColor];
    textFiled.leftView = label;
    textFiled.leftViewMode = UITextFieldViewModeAlways;
    textFiled.placeholder = placeholder;
    textFiled.tintColor = [UIColor whiteColor];
    textFiled.layer.cornerRadius = textFieldSize.height * 0.5;
    textFiled.layer.borderColor = [UIColor whiteColor].CGColor;
    textFiled.layer.borderWidth = IMBORDER_WIDTH_1PX;
    textFiled.layer.masksToBounds = (YES);
    return textFiled;
}
@end
