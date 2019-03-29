
//
//  IMGroupQRCodeViewController.m
//  IMChat
//
//  Created by 徐世杰 on 16/3/8.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "IMGroupQRCodeViewController.h"
//#import "IMQRCodeViewController.h"

@interface IMGroupQRCodeViewController () <IMActionSheetDelegate>

//@property (nonatomic, strong) IMQRCodeViewController *qrCodeVC;

@end

@implementation IMGroupQRCodeViewController

- (instancetype)initWithGroupModel:(IMGroup *)groupModel
{
    if (self = [super init]) {
        _group = groupModel;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    [self.view setBackgroundColor:[UIColor colorBlackBG]];
    [self setTitle:@"群二维码名片"];
    
//    [self.view addSubview:self.qrCodeVC.view];
//    [self addChildViewController:self.qrCodeVC];
    
    @weakify(self);
    [self addRightBarButtonWithImage:IMImage(@"nav_more") actionBlick:^{
        IMActionSheet *actionSheet = [[IMActionSheet alloc] initWithTitle:nil clickAction:^(NSInteger buttonIndex) {
            @strongify(self);
            if (buttonIndex == 1) {
//                [self.qrCodeVC saveQRCodeToSystemAlbum];
            }
        } cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"用邮件发送", @"保存图片", nil];
        [actionSheet show];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.qrCodeVC.avatarPath = self.group.groupAvatarPath;
//    self.qrCodeVC.username = self.group.groupName;
//    self.qrCodeVC.qrCode = self.group.groupID;
//    NSDate *date = [NSDate dateWithDaysFromNow:7];
//    self.qrCodeVC.introduction = [NSString stringWithFormat:@"该二维码7天内(%lu月%lu日前)有效，重新进入将更新", (long)date.month, (long)date.day];
}

#pragma mark - # Getter
//- (IMQRCodeViewController *)qrCodeVC
//{
//    if (_qrCodeVC == nil) {
//        _qrCodeVC = [[IMQRCodeViewController alloc] init];
//    }
//    return _qrCodeVC;
//}

@end
