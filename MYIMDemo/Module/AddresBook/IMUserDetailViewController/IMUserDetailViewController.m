//
//  IMUserDetailViewController.m
//  MYIMDemo
//
//  Created by admin on 2019/3/15.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "IMUserDetailViewController.h"
#import "IMUserSettingViewController.h"
#import "IMChatViewController.h"
#import "IMUserDetailBaseInfoCell.h"
#import "IMUserDetailChatButtonCell.h"
//#import "IMConversationModel.h"

typedef NS_ENUM(NSInteger, IMUserDetailVCSectionType) {
    IMUserDetailVCSectionTypeBaseInfo,
    IMUserDetailVCSectionTypeCustom,
    IMUserDetailVCSectionTypeDetailInfo,
    IMUserDetailVCSectionTypeFunction,
};

@interface IMUserDetailViewController ()

/// 用户id
@property (nonatomic, strong, readonly) NSString *userId;
/// 用户数据模型
@property (nonatomic, strong) IMUser *userModel;

@end

@implementation IMUserDetailViewController

- (instancetype)initWithUserId:(NSString *)userId
{
    if (self = [super init]) {
        _userId = userId;
    }
    return self;
}

- (instancetype)initWithUserModel:(IMUser *)userModel
{
    if (self = [super init]) {
        _userId = userModel.userID;
        _userModel = userModel;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    [self setTitle:@"详细资料"];
    [self.collectionView setBackgroundColor:[UIColor colorGrayBG]];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    @weakify(self);
    [self addRightBarButtonWithImage:IMImage(@"nav_more") actionBlick:^{
        @strongify(self);
        IMUserSettingViewController *detailSetiingVC = [[IMUserSettingViewController alloc] initWithUserModel:self.userModel];
        IMPushVC(detailSetiingVC);
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self requestUserDataWithUserId:self.userId];
}

#pragma mark - # Request
- (void)requestUserDataWithUserId:(NSString *)userId
{
    if (self.userModel) {
        [self loadUIWithUserModel:self.userModel];
    }
    
    // 请求完整的数据模型
//    _userModel = [[IMFriendHelper sharedFriendHelper] getFriendInfoByUserID:userId];
    [self loadUIWithUserModel:self.userModel];
}

#pragma mark - # UI
- (void)loadUIWithUserModel:(IMUser *)userModel
{
    @weakify(self);
    
    self.clear();
    
    // 基本信息
    self.addSection(IMUserDetailVCSectionTypeBaseInfo).sectionInsets(UIEdgeInsetsMake(15, 0, 0, 0));
    self.addCell(NSStringFromClass([IMUserDetailBaseInfoCell class])).toSection(IMUserDetailVCSectionTypeBaseInfo).withDataModel(userModel).eventAction(^ id(NSInteger eventType, id data) {
        @strongify(self);
        IMUser *userModel = data;
        NSURL *url = IMURL(userModel.avatarURL);
//        MWPhoto *photo = [MWPhoto photoWithURL:url];
//        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithPhotos:@[photo]];
//        UINavigationController *broserNavC = [[UINavigationController alloc] initWithRootViewController:browser];
//        [self presentViewController:broserNavC animated:NO completion:nil];
        return nil;
    });
    
    // 功能
    self.addSection(IMUserDetailVCSectionTypeFunction).sectionInsets(UIEdgeInsetsMake(20, 0, 40, 0));
    // 发消息
    self.addCell(NSStringFromClass([IMUserDetailChatButtonCell class])).toSection(IMUserDetailVCSectionTypeFunction).withDataModel(@"发消息").eventAction(^ id(NSInteger eventType, id data) {
        @strongify(self);
        IMChatViewController *chatVC = [[IMChatViewController alloc] initWithUserId:self.userModel.userID];
        if ([IMLaunchManager sharedInstance].tabBarController.selectedIndex != 0) {
            [self.navigationController popToRootViewControllerAnimated:NO];
            UINavigationController *navC = [IMLaunchManager sharedInstance].tabBarController.childViewControllers[0];
            [[IMLaunchManager sharedInstance].tabBarController setSelectedIndex:0];
            [chatVC setHidesBottomBarWhenPushed:YES];
            [navC pushViewController:chatVC animated:YES];
        }
        else {
            IMPushVC(chatVC);
        }
        return nil;
    });    
    [self reloadView];
}

@end
