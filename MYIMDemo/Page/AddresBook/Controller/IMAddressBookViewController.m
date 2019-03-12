#import "IMAddressBookTableViewCell.h"
#import "IMAddressBookViewController.h"
#import "IMChatViewController.h"
#import "IMConversationModel.h"
#import "IMConversationModel.h"
#import "IMEmojiGroup.h"
#import "IMLoginViewController.h"
#import "IMMessageModel.h"
#import "IMSearchMessageViewController.h"
#import "UIViewController+IMCategory.h"
#import <XMPPFramework/XMPPFramework.h>


@interface IMAddressBookViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate> {
    // searchBar高度
    CGFloat searchBarHeight;
}

@property (nonatomic, strong) UITableView                   *tableView;
// 搜索视图
@property (nonatomic, strong) UIView                        *headerView;
@property (nonatomic, strong) UISearchController            *searchViewCtrl;
@property (nonatomic, strong) IMSearchMessageViewController *searchCtrl;
@property (nonatomic, strong) UIView                        *titleView;
@property (nonatomic, strong) UIView                        *bottomLine;
// 数据源
@property (nonatomic, strong) NSMutableArray<XMPPUserMemoryStorageObject *>     *dataSource;
@end

@implementation IMAddressBookViewController

- (NSMutableArray<XMPPUserMemoryStorageObject *> *)dataSource {
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
    
}

- (void)im_getNewData{
    //  获得用户数据
    [self requestUserStoreage];
}

- (void)im_addSubViews{
    //  添加所有数据
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
    _searchViewCtrl.searchBar.placeholder            = @"搜索";
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
    
    // 设置自己的头像
    [[IMAppDefaultUtil sharedInstance] setUserAvatar:@"http://cname-yunke.shovesoft.com/group1/M00/00/1A/CgAHEVuMyv6AKj6uAABukEJ7t3I575.png"];
    
}

//  添加通知
- (void)addNotification{
    [IMNotificationCenter addObserver:self selector:@selector(rosterChangeNotification) name:kXmppRosterChangeNot object:nil];
}

//  请求好友列表
- (void)requestUserStoreage{
    XMPPRosterMemoryStorage *storage = KIMXMPPHelper.xmppRosterMemoryStorage;
    self.dataSource = [storage sortedUsersByAvailabilityName].mutableCopy;
    /*
    NSArray *array = [storage sortedUsersByName];
    [array enumerateObjectsUsingBlock:^(XMPPUserMemoryStorageObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"obj.displayName == %@",obj.displayName);
        NSLog(@"obj.ask == %@",obj.ask);
        NSLog(@"obj.subscription == %@",obj.subscription);
        NSLog(@"obj.nickname == %@",obj.nickname);
    }];
     */
}

//  好友列表改变
-(void)rosterChangeNotification{
    [self requestUserStoreage];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"IMAddressBookTableViewCell";
    IMAddressBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[IMAddressBookTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    XMPPUserMemoryStorageObject *object = self.dataSource[indexPath.row];
    cell.titleLabel.text = object.nickname?object.nickname:object.jid.user;
    cell.avaterImageView.image = object.photo? object.photo:[UIImage imageDefaultHeadPortrait];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [IMAddressBookTableViewCell cellLayoutHeight];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setSeparatorInset:UIEdgeInsetsMake(69, 12, 0, 0)];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XMPPUserMemoryStorageObject *object = self.dataSource[indexPath.row];
    IMConversationModel *conversation   = [[IMConversationModel alloc] init];
    conversation.chatToJid              = object.jid;
    conversation.conversationName       = object.jid.user;
    conversation.chatType               = IMMessageChatTypeSingle;
//    conversation.headImage              = object.photo? object.photo:[UIImage imageDefaultHeadPortrait];
    
    IMChatViewController *chatCtrl      = [IMChatViewController new];
    chatCtrl.title                      = conversation.conversationName;
    chatCtrl.hidesBottomBarWhenPushed   = YES;
    chatCtrl.conversation               = conversation;
    chatCtrl.isConversationInto         = NO;
    
    [self.navigationController pushViewController:chatCtrl animated:YES];
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


@implementation IMAddressBookViewController(Class)
+ (IMBaseNavigationController *)navAddressBookVc;{
    IMBaseNavigationController *navC = [[IMBaseNavigationController alloc] initWithRootViewController:[[[self class] alloc] init]];
    return navC;
}
@end
