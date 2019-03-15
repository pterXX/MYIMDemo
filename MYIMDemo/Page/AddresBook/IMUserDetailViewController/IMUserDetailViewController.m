//
//  IMUserDetailViewController.m
//  MYIMDemo
//
//  Created by admin on 2019/3/15.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "IMUserDetailViewController.h"

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
