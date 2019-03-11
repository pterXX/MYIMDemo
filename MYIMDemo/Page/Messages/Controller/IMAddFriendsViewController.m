//
//  IMAddFriendsViewController.m
//  MYIMDemo
//
//  Created by admin on 2019/3/8.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "IMAddFriendsViewController.h"
#import "IMSearchMessageViewController.h"
#import "IMMessagesListTableViewCell.h"

@interface IMAddFriendsViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate>
{
    // 选择的NSIndexPath
    NSIndexPath *selecteIndexPath;
    // searchBar高度
    CGFloat searchBarHeight;
}

@property (nonatomic, strong) UITableView        *tableView;
// 搜索视图
@property (nonatomic, strong) UIView             *headerView;
@property (nonatomic, strong) UISearchController *searchViewCtrl;
@property (nonatomic, strong) IMSearchMessageViewController *searchCtrl;
@property (nonatomic, strong) UIView             *titleView;
@property (nonatomic, strong) UIView             *bottomLine;
// 收到的json消息
@property (nonatomic, strong) NSString           *receiveJson;
// 记录正在聊天的会话
@property (nonatomic, strong) NSString           *conversationId;
// 数据源
@property (nonatomic, strong) NSMutableArray     *dataSource;
// 分段控制器数据源
@property (nonatomic, strong) NSMutableArray     *segmentDataSource;
// 分段控制器数据源menu
@property (nonatomic, strong) NSMutableArray     *menuDataSource;
@end

@implementation IMAddFriendsViewController

- (NSMutableArray *)dataSource {
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
    // Do any additional setup after loading the view.
}

- (void)im_layoutNavigation{
    self.title = @"添加好友";
}

- (void)im_addSubViews{
    self.isExtendLayout = NO;
    CGFloat systemVersion = [UIDevice currentSystemVersion].doubleValue;
    // iOS 11以前搜索框的高度是44 iOS 11及以后的高度是56
    searchBarHeight = systemVersion < 11.0 ? 44 : 56;
    
    _titleView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IMSCREEN_WIDTH, 44)];
    _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(IMSCREEN_WIDTH/4., 42, 40, 2)];
    _bottomLine.center = CGPointMake(IMSCREEN_WIDTH/4., 42);
    _bottomLine.backgroundColor = kSegmentItemColor;
    [_titleView addSubview:_bottomLine];
    
    _tableView                 = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate        = self;
    _tableView.dataSource      = self;
    _tableView.backgroundColor = KBGColor1;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    
    _tableView.sd_layout.bottomEqualToView(self.view).topSpaceToView(self.view, 0).leftEqualToView(self.view).rightEqualToView(self.view);
    
    // 提示网络不可用或无网络连接
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IMSCREEN_WIDTH, searchBarHeight)];
    
    // 搜索框
    _searchCtrl = [[IMSearchMessageViewController alloc] init];
    _searchViewCtrl = [[UISearchController alloc] initWithSearchResultsController:_searchCtrl];
    _searchViewCtrl.searchResultsUpdater             = _searchCtrl;
    _searchViewCtrl.delegate                         = self;
    _searchViewCtrl.searchBar.delegate               = _searchCtrl;
    _searchViewCtrl.searchBar.placeholder            = @"请输入账号";
    _searchViewCtrl.searchBar.searchBarStyle         = UISearchBarStyleDefault;
    // 包着搜索框外层的颜色
    _searchViewCtrl.searchBar.tintColor              = [UIColor darkGrayColor];
    _searchViewCtrl.searchBar.backgroundColor        = [IMColorTools colorWithHexString:@"0xffffff"];
    // 搜索时，背景变暗色
    _searchViewCtrl.dimsBackgroundDuringPresentation = NO;
    self.definesPresentationContext                  = YES;
    _searchViewCtrl.searchBar.searchBarStyle         = UISearchBarStyleMinimal;
    
    _searchCtrl.navigationBarCtrl                    = self.navigationController;
    _searchCtrl.searchBar                            = _searchViewCtrl.searchBar;
    [_headerView addSubview:_searchCtrl.searchBar];
    self.tableView.tableHeaderView = _headerView;
    // 搜索按钮点击
    kWeakSelf;
    [_searchCtrl setKeyboardRuturnBtnClick:^(NSString * _Nonnull str) {
        //  添加好友
        [weakSelf addFriend:str];
    }];
    
    
}

//  添加好友
- (void)addFriend:(NSString *)uesrID{
    if ([uesrID isEmptyString] && KIMXMPPHelper.userHelper.isLogin) return;
    __block NSString * uesrIDstr = uesrID;
    NSString *str = IMStirngFormat(@"是否添加好友\"%@\"",uesrID);
    kWeakSelf;
    [self alertWithTitle:str message:@"此功能只做简单的添加好友功能。具体实现可以根据产品需求改变" cancel:^(BOOL ok) {
        if (ok) {
            IMUser *user =  [[IMUser alloc] init];
            //  userID和userName 设置为同一个是方便调试，后期可以根据需求改变相应的参数 ·
            user.userID = uesrIDstr;
            user.username = uesrIDstr;
            user.avatarURL = kDebugAvatarURL;
            [KIMXMPPHelper addFriend:user];
            [SVProgressHUD showInfoWithStatus:IMStirngFormat(@"等待\"%@\"接受请求",uesrIDstr)];
            [SVProgressHUD dismissWithDelay:2];
            //  返回上个页面
            [weakSelf im_backHandle];
        }
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"IMMessagesListTableViewCell";
    IMMessagesListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[IMMessagesListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (self.dataSource.count) {
        IMConversationModel *model = self.dataSource[indexPath.row];
        [cell setConversation:model];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setSeparatorInset:UIEdgeInsetsMake(69, 12, 0, 0)];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    selecteIndexPath                    = indexPath;
}

#pragma mark - UISearchControllerDelegate代理
- (void)willPresentSearchController:(UISearchController *)searchController
{
    self.tabBarController.tabBar.hidden   = YES;
    _searchCtrl.searchBar.backgroundColor = [IMColorTools colorWithHexString:@"0xf0eff5"];
}

- (void)didDismissSearchController:(UISearchController *)searchController
{
    self.tabBarController.tabBar.hidden   = NO;
    _searchCtrl.searchBar.backgroundColor = [IMColorTools colorWithHexString:@"0xffffff"];
}

@end
