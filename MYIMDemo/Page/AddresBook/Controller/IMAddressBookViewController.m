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
#import "IMNewContactViewController.h"


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
@property (nonatomic, strong) NSMutableArray     *fisrtSectionDataSource;
// 数据源
@property (nonatomic, strong) NSMutableArray<IMUser *>     *dataSource;
@end

@implementation IMAddressBookViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        //  这个通知必须放在init
         [self addNotification];
    }
    return self;
}

- (NSMutableArray<IMUser *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (NSMutableArray *)fisrtSectionDataSource{
    if (!_fisrtSectionDataSource) {
        _fisrtSectionDataSource = [NSMutableArray arrayWithObjects:@"新的朋友", nil];
    }
    return _fisrtSectionDataSource;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)im_layoutNavigation{
    
}

- (void)im_getNewData{
    //  获得用户数据
    self.dataSource = KIMXMPPHelper.userHelper.friendArray.mutableCopy;
    [self.tableView reloadData];
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
    
    _tableView                 = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
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
}

//  添加通知
- (void)addNotification{
    kWeakSelf;
    [KIMXMPPHelper addRosterChangeNotificationObserver:self usingBlock:^{
        weakSelf.dataSource = KIMXMPPHelper.userHelper.friendArray.mutableCopy;
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? self.fisrtSectionDataSource.count:self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSString *cellIdentifier = @"TableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.textLabel.text = self.fisrtSectionDataSource[indexPath.row];
        return cell;
    }else{
        NSString *cellIdentifier = @"IMAddressBookTableViewCell";
        IMAddressBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[IMAddressBookTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        IMUser *object = (IMUser *)self.dataSource[indexPath.row];
        [cell setUser:object];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [IMAddressBookTableViewCell cellLayoutHeight];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setSeparatorInset:UIEdgeInsetsMake(69, 12, 0, 0)];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        IMNewContactViewController *chatCtrl = [IMNewContactViewController new];
        chatCtrl.hidesBottomBarWhenPushed   = YES;
        [self.navigationController pushViewController:chatCtrl animated:YES];
    }else{
        IMUser *object = self.dataSource[indexPath.row];
        IMConversationModel *conversation   = [[IMConversationModel alloc] init];
        conversation.chatToJid              = object.userJid;
        conversation.conversationName       = object.showName;
        conversation.chatType               = IMMessageChatTypeSingle;
        //    conversation.headImage              = object.photo? object.photo:[UIImage imageDefaultHeadPortrait];
        
        IMChatViewController *chatCtrl      = [IMChatViewController new];
        chatCtrl.title                      = conversation.conversationName;
        chatCtrl.hidesBottomBarWhenPushed   = YES;
        chatCtrl.conversation               = conversation;
        chatCtrl.isConversationInto         = NO;
        
        [self.navigationController pushViewController:chatCtrl animated:YES];
    }
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
