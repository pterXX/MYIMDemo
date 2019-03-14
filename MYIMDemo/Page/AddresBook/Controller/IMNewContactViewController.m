//
//  IMNewsContactViewController.m
//  MYIMDemo
//
//  Created by admin on 2019/3/13.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "IMNewContactViewController.h"
#import "IMNewContactTableViewCell.h"
#import "IMAddFriendsViewController.h"
#import "IMChatViewController.h"
#import "IMConversationModel.h"
#import "IMConversationModel.h"
#import "IMEmojiGroup.h"
#import "IMLoginViewController.h"
#import "IMMessageModel.h"
#import "IMSearchMessageViewController.h"
#import "UIViewController+IMCategory.h"
#import <XMPPFramework/XMPPFramework.h>


@interface IMNewContactViewController ()<UITableViewDelegate, UITableViewDataSource,IMNewContactTableViewCellDelegate>
@property (nonatomic, strong) UITableView                   *tableView;
// 数据源
@property (nonatomic, strong) NSMutableArray<IMUser *>     *dataSource;
@end

@implementation IMNewContactViewController

- (NSMutableArray<IMUser *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNotification];
}

- (void)im_layoutNavigation{
    self.title = @"新的朋友";
    kWeakSelf;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barTitle:@"添加朋友" callBack:^(UIBarButtonItem * _Nonnull barItem) {
        IMAddFriendsViewController *vc = [[IMAddFriendsViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)im_getNewData{
    //  获得用户数据
    [self requestUserStoreage];
}

- (void)im_addSubViews{
    //  添加所有数据
    self.isExtendLayout = NO;
    
    _tableView                 = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate        = self;
    _tableView.dataSource      = self;
    _tableView.backgroundColor = KBGColor1;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    
    _tableView.sd_layout.bottomEqualToView(self.view).topSpaceToView(self.view, 0).leftEqualToView(self.view).rightEqualToView(self.view);
}

//  添加通知
- (void)addNotification{
    // 订阅通知
    kWeakSelf;
    [KIMXMPPHelper addSubscriptionRequestNotificationObserver:self usingBlock:^(XMPPPresence * _Nonnull presence) {
        if(!presence) return;
        [weakSelf requestUserStoreage];
    }];
}

//  请求好友列表
- (void)requestUserStoreage{
    self.dataSource = [KIMXMPPHelper userHelper].addFriendArray;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"IMNewContactTableViewCell";
    IMNewContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[IMNewContactTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell setDelegate:self];
    [cell setUser:self.dataSource[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [IMNewContactTableViewCell cellLayoutHeight];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setSeparatorInset:UIEdgeInsetsMake(69, 12, 0, 0)];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - IMNewContactTableViewCellDelegate
- (void)newContactTableViewCell:(nonnull IMNewContactTableViewCell *)cell agreeButDidTouchUp:(nonnull IMUser *)user {
    //  同意请求
    [KIMXMPPHelper acceptPresenceSubscriptionRequestFrom:user.userJid];
}

- (void)newContactTableViewCell:(nonnull IMNewContactTableViewCell *)cell rejectButDidTouchUp:(nonnull IMUser *)user {
    //  拒绝请求
    [KIMXMPPHelper rejectPresenceSubscriptionRequestFrom:user.userJid];
}


@end

