#import "IMAddContactsViewController.h"
#import "IMAddressBookTableViewCell.h"
#import "IMChatViewController.h"
#import "IMContactItemCell.h"
#import "IMContactsAngel.h"
#import "IMContactsSearchResultViewController.h"
#import "IMContactsViewController.h"
#import "IMConversationModel.h"
#import "IMConversationModel.h"
#import "IMEmojiGroup.h"
#import "IMLoginViewController.h"
#import "IMMessageModel.h"
#import "IMNewContactViewController.h"
#import "IMUserDetailViewController.h"
#import "UIViewController+Category.h"
#import <XMPPFramework/XMPPFramework.h>

@interface IMContactsViewController ()
/// 列表
@property (nonatomic, strong) UITableView *tableView;

/// 列表数据及控制中心
@property (nonatomic, strong) IMContactsAngel *listAngel;

/// 总好友数
@property (nonatomic, strong) UILabel *footerLabel;

// 搜索视图
@property (nonatomic, strong) IMSearchController *searchController;
@end

@implementation IMContactsViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        initTabBarItem(self.tabBarItem, @"通讯录", @"tabbar_contacts", @"tabbar_contactsHL");
        //  这个通知必须放在init
         [self p_addNotification];
    }
    return self;
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
     @weakify(self);
    [self addRightBarButtonWithImage:[UIImage imageNamed:@"contacts_add_friend"] actionBlick:^{
        @strongify(self);
        IMAddContactsViewController *add = [[IMAddContactsViewController alloc] init];
        IMPushVC(add);
    }];
}

- (void)im_getNewData{
    [self p_resterStorage];
}

- (void)im_addSubViews{
    self.navigationItem.title = @"通讯录";
    self.isExtendLayout = NO;
    self.tableView                              = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor              = [UIColor colorGrayBG];
    self.tableView.separatorStyle               = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight           = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.tableHeaderView              = self.searchController.searchBar;
    [self.tableView setSectionIndexColor:[UIColor colorBlackForNavBar]];
    [self.tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    self.tableView.tableFooterView              = self.footerLabel;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    @weakify(self);
    self.listAngel = [[IMContactsAngel alloc] initWithHostView:self.tableView pushAction:^(__kindof UIViewController * _Nonnull vc) {
        @strongify(self);
        IMPushVC(vc);
    }];
}

//  添加通知
- (void)p_addNotification{
    @weakify(self);
    [KIMXMPPHelper addRosterChangeNotificationObserver:self usingBlock:^{
        @strongify(self);
        [self p_resterStorage];
    }];
    
    [KIMXMPPHelper addSubscriptionRequestNotificationObserver:self usingBlock:^(XMPPPresence * _Nonnull presence) {
    }];
}

- (void)p_resterStorage{
    [self.listAngel resetListWithContactsData:KIMXMPPHelper.userHelper.bothFriendArray];
    [self.footerLabel setText:IMStirngFormat(@"%ld位联系人",KIMXMPPHelper.userHelper.bothFriendArray.count)];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 2;
//}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return section == 0 ? self.fisrtSectionDataSource.count:self.dataSource.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.section == 0) {
//        NSString *cellIdentifier = @"TableViewCell";
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//        if (!cell) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//        }
//        cell.textLabel.text = self.fisrtSectionDataSource[indexPath.row];
//        return cell;
//    }else{
//        NSString *cellIdentifier = @"IMAddressBookTableViewCell";
//        IMAddressBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//        if (!cell) {
//            cell = [[IMAddressBookTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//        }
//        IMUser *object = (IMUser *)self.dataSource[indexPath.row];
//        [cell setUser:object];
//
//        return cell;
//    }
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return [IMAddressBookTableViewCell cellLayoutHeight];
//}
//
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    [cell setSeparatorInset:UIEdgeInsetsMake(69, 12, 0, 0)];
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (indexPath.section == 0) {
//        IMNewContactViewController *chatCtrl = [IMNewContactViewController new];
//        chatCtrl.hidesBottomBarWhenPushed   = YES;
//        [self.navigationController pushViewController:chatCtrl animated:YES];
//    }else{
//        IMUser *object = self.dataSource[indexPath.row];
//        IMConversationModel *conversation   = [[IMConversationModel alloc] init];
//        conversation.chatToJid              = object.userJid;
//        conversation.conversationName       = object.showName;
//        conversation.chatType               = IMMessageChatTypeSingle;
//        //    conversation.headImage              = object.photo? object.photo:[UIImage imageDefaultHeadPortrait];
//
//        IMChatViewController *chatCtrl      = [IMChatViewController new];
//        chatCtrl.title                      = conversation.conversationName;
//        chatCtrl.hidesBottomBarWhenPushed   = YES;
//        chatCtrl.conversation               = conversation;
//        chatCtrl.isConversationInto         = NO;
//
//        [self.navigationController pushViewController:chatCtrl animated:YES];
//    }
//}

#pragma mark - # Getters
- (IMSearchController *)searchController
{
    if (_searchController == nil) {
        IMContactsSearchResultViewController *searchVC = [[IMContactsSearchResultViewController alloc] init];
        @weakify(self);
        [searchVC setItemSelectedAction:^(IMContactsSearchResultViewController *searchVC, IMUser *userModel) {
            @strongify(self);
            [self.searchController setActive:NO];
            IMUserDetailViewController *detailVC = [[IMUserDetailViewController alloc] initWithUserModel:userModel];
            IMPushVC(detailVC);
        }];
        _searchController = [IMSearchController createWithResultsContrller:searchVC];
        [_searchController setEnableVoiceInput:YES];
    }
    return _searchController;
}

- (UILabel *)footerLabel
{
    if (_footerLabel == nil) {
        _footerLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, IMSCREEN_WIDTH, 50.0f)];
        [_footerLabel setTextAlignment:NSTextAlignmentCenter];
        [_footerLabel setFont:[UIFont systemFontOfSize:17.0f]];
        [_footerLabel setTextColor:[UIColor grayColor]];
    }
    return _footerLabel;
}
@end


@implementation IMContactsViewController(Class)
+ (IMBaseNavigationController *)navAddressBookVc;{
    IMBaseNavigationController *navC = [[IMBaseNavigationController alloc] initWithRootViewController:[[[self class] alloc] init]];
    return navC;
}
@end
