//
//  IMLoginViewController.m
//  MYIMDemo
//
//  Created by admin on 2019/3/5.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "IMLoginViewController.h"
#import "IMSignUpViewController.h"
#import "IMBaseTabBarController.h"

@interface IMLoginViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UIButton    *signUpBtn;// 注册按钮
@property (nonatomic, strong) UIButton    *signInBtn;// 登录按钮
@property (nonatomic, strong) UILabel     *nameLogo;//  logo
@property (nonatomic, strong) UITextField *passwordField;// 密码
@property (nonatomic, strong) UITextField *userField;// 用户名
@end

#define kTextFieldSize CGSizeMake(325,44);

@implementation IMLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isTouchEndEditing = YES;
    // Do any additional setup after loading the view.
}



- (void)im_addSubViews{
    //     CGFloat systemVersion = [UIDevice currentSystemVersion].doubleValue;
    //  背景
    [self.view addSubview:({
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageLoginBackground]];
        imageView.contentMode = UIViewContentModeBottom;
        imageView.frame = self.view.bounds;
        imageView;
    })];
    
    
    // logo
    [self.view addSubview:({
        self.nameLogo = [[UILabel alloc] initWithFrame:CGRectMake((IMSCREEN_WIDTH - 320) * 0.5, IMNAVBAR_HEIGHT + IMSTATUSBAR_HEIGHT + 50, 320, 50)];
        self.nameLogo.text          = @"IMDemo Sign In";
        self.nameLogo.textAlignment = NSTextAlignmentCenter;
        self.nameLogo.textColor     = [UIColor whiteColor];
        self.nameLogo.font          = [UIFont fontLoginLogo];
        self.nameLogo;
    })];
    
    CGSize textFieldSize =  kTextFieldSize;
    //  账号
    [self.view addSubview:({
        self.userField      = [self addTextField:@"账号" placeholder:@"请输入账号" ];
        self.userField.size = textFieldSize;
        self.userField.left = (self.view.width - self.userField.width) * 0.5;
        self.userField.top = self.nameLogo.bottom + 40;
        self.userField;
    })] ;
    
    // 密码
    [self.view addSubview:({
        self.passwordField                 = [self addTextField:@"密码" placeholder:@"请输入密码" ];
        self.passwordField.size            = textFieldSize;
        self.passwordField.left            = self.userField.left;
        self.passwordField.top             = self.userField.bottom + 10;
        self.passwordField.secureTextEntry = YES;
        self.passwordField.returnKeyType   = UIReturnKeyGo;
        self.passwordField.delegate        = self;
        self.passwordField;
    })];
    
    //  登录按钮
    [self.view addSubview:({
        NSString *title = @"登录";
        UIColor *titleColor                = [UIColor colorTextGray];
        UIImage *image                     = [UIImage imageWithColor:[UIColor whiteColor]];
        self.signInBtn                     = [UIButton buttonWithType:UIButtonTypeCustom];
        self.signInBtn.left                = self.userField.left;
        self.signInBtn.top                 = self.passwordField.bottom + 20;
        self.signInBtn.size                = textFieldSize;
        self.signInBtn.layer.cornerRadius  = textFieldSize.height * 0.5;
        self.signInBtn.layer.borderColor   = [UIColor whiteColor].CGColor;
        self.signInBtn.layer.borderWidth   = 1;
        self.signInBtn.layer.masksToBounds = (YES);
        [self.signInBtn setTitle:title forState:UIControlStateNormal];
        [self.signInBtn setTitle:title forState:UIControlStateSelected];
        [self.signInBtn setTitle:title forState:UIControlStateFocused];
        [self.signInBtn setTitleColor:titleColor forState:UIControlStateNormal];
        [self.signInBtn setTitleColor:titleColor forState:UIControlStateSelected];
        [self.signInBtn setTitleColor:titleColor forState:UIControlStateFocused];
        [self.signInBtn setBackgroundImage:image forState:UIControlStateNormal];
        [self.signInBtn setBackgroundImage:image forState:UIControlStateSelected];
        [self.signInBtn setBackgroundImage:image forState:UIControlStateFocused];
        self.signInBtn;
    })];
   
    //  注册按钮
    [self.view addSubview:({
        NSString *title = @"没有账号?注册新用户";
        UIColor *titleColor                = [UIColor whiteColor];
        self.signUpBtn                     = [UIButton buttonWithType:UIButtonTypeCustom];
        self.signUpBtn.left                = self.userField.left;
        self.signUpBtn.bottom              = self.view.height - 100;
        self.signUpBtn.size                = textFieldSize;
        self.signUpBtn.titleLabel.font     = [UIFont fontLoginSignUp];
        [self.signUpBtn setTitle:title forState:UIControlStateNormal];
        [self.signUpBtn setTitle:title forState:UIControlStateSelected];
        [self.signUpBtn setTitle:title forState:UIControlStateFocused];
        [self.signUpBtn setTitleColor:titleColor forState:UIControlStateNormal];
        [self.signUpBtn setTitleColor:titleColor forState:UIControlStateSelected];
        [self.signUpBtn setTitleColor:titleColor forState:UIControlStateFocused];
        self.signUpBtn;
    })];
    
     [self signBtnWithEvents];
}


/**
 登录按钮的点击
 */
- (void)signBtnWithEvents{
    kWeakSelf;
    //  点击事件
    [self.signInBtn addIMCallBackAction:^(UIButton *button) {
        button.enabled = NO;
        button.alpha = 0.5f;
    } forControlEvents:UIControlEventTouchDown];
    //  手指提起的事件
    [self.signInBtn addIMCallBackAction:^(UIButton *button) {
        button.enabled = YES;
        button.alpha = 1.0f;
        [weakSelf signIn];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [self.signUpBtn addIMCallBackAction:^(UIButton *button) {
        button.enabled = NO;
        button.alpha = 0.5f;
    } forControlEvents:UIControlEventTouchDown];
    //  手指提起的事件
    [self.signUpBtn addIMCallBackAction:^(UIButton *button) {
        button.enabled = YES;
        button.alpha = 1.0f;
        [weakSelf signUp];
    } forControlEvents:UIControlEventTouchUpInside];
}

/**
 初始化TextField
 
 @param title 标题
 @param placeholder 占位名
 @return 初始化后的UITextField
 */
- (UITextField *)addTextField:(NSString *)title placeholder:(NSString *)placeholder
{
    CGSize textFieldSize = kTextFieldSize;
    UILabel *label      = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, textFieldSize.height)];
    label.text          = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.font          = [UIFont fontLoginUserAndPassword];
    label.textColor = [UIColor whiteColor];
    
    UITextField *textField           = [[UITextField alloc] init];
    textField.font                   = [UIFont fontLoginUserAndPassword];
    textField.textColor              = [UIColor whiteColor];
    textField.leftView               = label;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.leftViewMode           = UITextFieldViewModeAlways;
    textField.placeholder            = placeholder;
    textField.tintColor              = [UIColor whiteColor];
    textField.layer.cornerRadius     = textFieldSize.height * 0.5;
    textField.layer.borderColor      = [UIColor whiteColor].CGColor;
    textField.layer.borderWidth      = 1;
    textField.layer.masksToBounds = (YES);
    [textField setValue:SETCOLOR(255, 255, 255, 0.7) forKeyPath:@"_placeholderLabel.textColor"];
    return textField;
}


/**
 检查文本输入框是否有值
 
 @return BOOL yes 表示有值 NO便是不存在值
 */
- (BOOL)checkTextFieldForValue{
    BOOL ok =  YES;
    if ([self.userField.text isEmptyString]) {
        ok = NO;
        [SVProgressHUD showInfoWithStatus:self.userField.placeholder];
        [SVProgressHUD dismissWithDelay:2];
    }else if ([self.passwordField.text isEmptyString]) {
        ok = NO;
        [SVProgressHUD showInfoWithStatus:self.passwordField.placeholder];
        [SVProgressHUD dismissWithDelay:2];
    }
    
    return ok;
}


/**
 登录
 */
- (void)signIn{
    kWeakSelf;
    [self.view endEditing:YES];
    if ([self checkTextFieldForValue]) {
        //  文本框不z存在空值
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [SVProgressHUD showWithStatus:@"登录中..."];
        
        if ([self checkTextFieldForValue]) {
            NSString *username = self.userField.text;
            NSString *password = self.passwordField.text;//123456
            [KIMXMPPHelper loginWithName:username andPassword:password success:^{
                [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                [SVProgressHUD dismissWithDelay:2];
                [weakSelf loginSuccess];
            } fail:^(NSError *error) {
                NSLog(@"error %@",error);
                if (error.code == IMXMPPErrorCodeConnect) {
                    [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"登录失败"];
                }
                [SVProgressHUD dismissWithDelay:2];
            }];
        }
    }
}


/**
 注册
 */
- (void)signUp{
    [self.view endEditing:YES];
    IMSignUpViewController *vc = [[IMSignUpViewController alloc] init];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:nil];
}


/**
 实现UITextField代理方法
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self signIn];
    return YES;
}

#pragma mark - notification event

/**
 登录成功
 */
- (void)loginSuccess{
    //  判断是否登录
    if ([IMUserHelper sharedHelper].isLogin) {
        //  切换根视图
        if (self.loginSuccessBlock) {
            self.loginSuccessBlock();
        }
    }
}
@end
