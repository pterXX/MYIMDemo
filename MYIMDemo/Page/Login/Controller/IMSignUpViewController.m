//
//  IMSignUpViewController.m
//  MYIMDemo
//
//  Created by admin on 2019/3/5.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "IMSignUpViewController.h"
#import "IMMessageViewController.h"

@interface IMSignUpViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UIButton    *signUpBtn;// 注册按钮
@property (nonatomic, strong) UIButton    *signInBtn;// 登录按钮
@property (nonatomic, strong) UILabel     *nameLogo;//  logo
@property (nonatomic, strong) UITextField *passwordField;// 密码
@property (nonatomic, strong) UITextField *confirmPasswordField;// 确认密码
@property (nonatomic, strong) UITextField *userField;// 用户名
@end

#define kTextFieldSize CGSizeMake(325,44);

@implementation IMSignUpViewController

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
        self.nameLogo.text          = @"IMDemo Sign Up";
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
    
    // 确认密码
    [self.view addSubview:({
        self.confirmPasswordField                 = [self addTextField:@"确认密码" placeholder:@"确认密码" ];
        self.confirmPasswordField.size            = textFieldSize;
        self.confirmPasswordField.left            = self.userField.left;
        self.confirmPasswordField.top             = self.passwordField.bottom + 10;
        self.confirmPasswordField.secureTextEntry = YES;
        self.confirmPasswordField.returnKeyType   = UIReturnKeyGo;
        self.confirmPasswordField.delegate        = self;
        self.confirmPasswordField;
    })];
    
    //  注册按钮
    [self.view addSubview:({
        NSString *title = @"注册";
        UIColor *titleColor                = [UIColor colorTextGray];
        UIImage *image                     = [UIImage imageWithColor:[UIColor whiteColor]];
        self.signUpBtn                     = [UIButton buttonWithType:UIButtonTypeCustom];
        self.signUpBtn.left                = self.userField.left;
        self.signUpBtn.top                 = self.confirmPasswordField.bottom + 20;
        self.signUpBtn.size                = textFieldSize;
        self.signUpBtn.layer.cornerRadius  = textFieldSize.height * 0.5;
        self.signUpBtn.layer.borderColor   = [UIColor whiteColor].CGColor;
        self.signUpBtn.layer.borderWidth   = 1;
        self.signUpBtn.layer.masksToBounds = (YES);
        [self.signUpBtn setTitle:title forState:UIControlStateNormal];
        [self.signUpBtn setTitle:title forState:UIControlStateSelected];
        [self.signUpBtn setTitle:title forState:UIControlStateFocused];
        [self.signUpBtn setTitleColor:titleColor forState:UIControlStateNormal];
        [self.signUpBtn setTitleColor:titleColor forState:UIControlStateSelected];
        [self.signUpBtn setTitleColor:titleColor forState:UIControlStateFocused];
        [self.signUpBtn setBackgroundImage:image forState:UIControlStateNormal];
        [self.signUpBtn setBackgroundImage:image forState:UIControlStateSelected];
        [self.signUpBtn setBackgroundImage:image forState:UIControlStateFocused];
        self.signUpBtn;
    })];
    
    //  注册按钮
    [self.view addSubview:({
        NSString *title = @"已有账号,点击登录";
        UIColor *titleColor                = [UIColor whiteColor];
        self.signInBtn                     = [UIButton buttonWithType:UIButtonTypeCustom];
        self.signInBtn.left                = self.userField.left;
        self.signInBtn.bottom              = self.view.height - 100;
        self.signInBtn.size                = textFieldSize;
        self.signInBtn.titleLabel.font     = [UIFont fontLoginSignUp];
        [self.signInBtn setTitle:title forState:UIControlStateNormal];
        [self.signInBtn setTitle:title forState:UIControlStateSelected];
        [self.signInBtn setTitle:title forState:UIControlStateFocused];
        [self.signInBtn setTitleColor:titleColor forState:UIControlStateNormal];
        [self.signInBtn setTitleColor:titleColor forState:UIControlStateSelected];
        [self.signInBtn setTitleColor:titleColor forState:UIControlStateFocused];
        self.signInBtn;
    })];
    
    [self signBtnWithEvents];
}


/**
 登录按钮的点击
 */
- (void)signBtnWithEvents{
    kWeakSelf;
    //  点击事件
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
    NSString *user            = self.userField.text;
    NSString *password        = self.passwordField.text;
    NSString *confirmPassword = self.confirmPasswordField.text;
    
    if ([user isEmptyString]) {
        ok = NO;
        [SVProgressHUD showInfoWithStatus:self.userField.placeholder];
    }else if ([password isEmptyString]) {
        ok = NO;
        [SVProgressHUD showInfoWithStatus:self.passwordField.placeholder];
    }else if ([confirmPassword isEmptyString] || ![confirmPassword isEqualToString:password]) {
        ok = NO;
        [SVProgressHUD showInfoWithStatus:self.confirmPasswordField.placeholder];
    }
    [SVProgressHUD dismissWithDelay:2];
    return ok;
}


/**
 登录
 */
- (void)signIn{
    [self dismissViewControllerAnimated:YES completion:nil];
}


/**
 注册
 */
- (void)signUp{
    kWeakSelf;
    [self.view endEditing:YES];
    if ([self checkTextFieldForValue]) {
        //  文本框不z存在空值
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [SVProgressHUD showWithStatus:@"注册中..."];
        
        if ([self checkTextFieldForValue]) {
            NSString *username = self.userField.text;
            NSString *password = self.passwordField.text;//123456
            [KIMXMPPHelper registerWithName:username andPassword:password success:^{
                [SVProgressHUD showSuccessWithStatus:@"注册成功,请登录"];
                [SVProgressHUD dismissWithDelay:2];
                [weakSelf loginSuccess];
            } fail:^(NSError *error) {
                NSLog(@"error %@",error);
                if (error.code == IMXMPPErrorCodeConnect) {
                    [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
                }else if (error.code == IMXMPPErrorCodeDidRegister){
                    [SVProgressHUD showErrorWithStatus:@"已存在用户"];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"注册失败"];
                }
                [SVProgressHUD dismissWithDelay:2];
            }];
        }
    }
}

/**
 实现UITextField代理方法
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self signUp];
    return YES;
}

#pragma mark - notification event

/**
 登录成功
 */
- (void)loginSuccess{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
