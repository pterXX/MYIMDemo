//
//  IMConversationViewController.m
//  IMChat
//
//  Created by 李伯坤 on 16/1/23.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "IMConversationViewController.h"
#import "IMConversationAngel.h"
#import "IMNetworkStatusManager.h"
#import "IMMessageManager+ConversationRecord.h"
#import "IMConversation+IMUser.h"
#import "IMFriendHelper.h"
#import "IMAddMenuView.h"

#import "IMSearchController.h"
#import "IMContactsSearchResultViewController.h"
#import "IMChatViewController+Conversation.h"
#import "IMUserDetailViewController.h"

#import <Masonry/Masonry.h>

@interface IMConversationViewController () <IMMessageManagerConvVCDelegate>
{
    IMNetworkStatusManager *networkStatusManger;
}

/// 列表
@property (nonatomic, strong) UITableView *tableView;

/// 列表数据及控制中心
@property (nonatomic, strong) IMConversationAngel *listAngel;

@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, strong) IMSearchController *searchController;

@property (nonatomic, strong) IMAddMenuView *addMenuView;

@end

@implementation IMConversationViewController

- (id)init
{
    if (self = [super init]) {
        initTabBarItem(self.tabBarItem, @"消息", @"tabbar_mainframe", @"tabbar_mainframeHL");
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    [self p_setNavtitleWithStatusString:nil];
    
    // 初始化界面视图控件
    [self p_loadUI];
    
    // 初始化列表模块
    [self p_initListModule];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self p_startNetworkMonitoring];
    [[IMMessageManager sharedInstance] setConversationDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //TODO: 临时写法
    [self updateConversationData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.addMenuView.isShow) {
        [self.addMenuView dismiss];
    }
}

#pragma mark - # Delegate
//MARK: IMMessageManagerConvVCDelegate
- (void)updateConversationData
{
    [[IMMessageManager sharedInstance] conversationRecord:^(NSArray *data) {
        for (IMConversation *conversation in data) {
            if (conversation.convType == IMConversationTypePersonal) {
                IMUser *user = [[IMFriendHelper sharedFriendHelper] getFriendInfoByUserID:conversation.partnerID];
                [conversation updateUserInfo:user];
            }
            else if (conversation.convType == IMConversationTypeGroup) {
                IMGroup *group = [[IMFriendHelper sharedFriendHelper] getGroupInfoByGroupID:conversation.partnerID];
                [conversation updateGroupInfo:group];
            }
        }
        [self p_updateConvsationModuleWithData:data];
    }];
}

#pragma mark - # Private Methods
- (void)p_loadUI
{
    // 列表
    self.tableView = self.view.addTableView(1)
    .backgroundColor([UIColor whiteColor])
    .tableHeaderView(self.searchController.searchBar)
    .tableFooterView([UIView new])
    .separatorStyle(UITableViewCellSeparatorStyleNone)
    .masonry(^(MASConstraintMaker *make) {
       make.edges.mas_equalTo(0);
    }).view;
    
    // 顶部logo
    self.tableView.addImageView(1001)
    .image(IMImage(@"conv_wechat_icon"))
    .masonry(^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.tableView);
        make.bottom.mas_equalTo(self.tableView.mas_top).mas_offset(-35);
    });
    
    // 右侧按钮
    @weakify(self);
    [self addRightBarButtonWithImage:IMImage(@"nav_add") actionBlick:^{
        @strongify(self);
        if (self.addMenuView.isShow) {
            [self.addMenuView dismiss];
        }
        else {
            [self.addMenuView showInView:self.navigationController.view];
        }
    }];
}

- (void)p_initListModule
{
    @weakify(self);
    self.listAngel = [[IMConversationAngel alloc] initWithHostView:self.tableView badgeStatusChangeAction:^(NSString *badge) {
        @strongify(self);
        [self.tabBarItem setBadgeValue:badge];
    }];
    
    // 搜索，网络失败
    self.listAngel.addSection(IMConversationSectionTagAlert);
    // 置顶文章
    self.listAngel.addSection(IMConversationSectionTagTopArticle);
    // 播放内容
    self.listAngel.addSection(IMConversationSectionTagPlay);
    // 置顶会话
    self.listAngel.addSection(IMConversationSectionTagTopConversation);
    // 普通会话
    self.listAngel.addSection(IMConversationSectionTagConv);
    
    [self.tableView reloadData];
}

/// 更新会话模块的信息
- (void)p_updateConvsationModuleWithData:(NSArray *)data
{
    @weakify(self);
    self.listAngel.sectionForTag(IMConversationSectionTagConv).clear();
    self.listAngel.addCells(@"IMConversationCell").toSection(IMConversationSectionTagConv).withDataModelArray(data).selectedAction(^ (IMConversation *conversation) {
        @strongify(self);
        [conversation setUnreadCount:0];
        [self.listAngel reloadBadge];
        IMChatViewController *chatVC = [[IMChatViewController alloc] initWithConversation:conversation];
        IMPushVC(chatVC);
    });

    [self.tableView reloadData];
}

/// 开始网络监控
- (void)p_startNetworkMonitoring
{
    networkStatusManger = [[IMNetworkStatusManager alloc] init];
    [networkStatusManger startNetworkStatusMonitoring];
    @weakify(self);
    [networkStatusManger setNetworkChangedBlock:^(IMNetworkStatus status){
        @strongify(self);
        self.listAngel.sectionForTag(IMConversationSectionTagAlert).clear();
        if (status == IMNetworkStatusNone) {
            [self.navigationItem setTitle:@"未连接"];
            self.listAngel.addCell(@"IMConversationNoNetCell").toSection(IMConversationSectionTagAlert).viewTag(IMConversationCellTagNoNet);
        }
        else {
            [self p_setNavtitleWithStatusString:nil];
        }
        [self.tableView reloadData];
    }];
}

- (void)p_setNavtitleWithStatusString:(NSString *)statusString
{
    NSString *title = @"消息";
    title = statusString.length > 0 ? [title stringByAppendingFormat:@"(%@)", statusString] : title;
    [self.navigationItem setTitle:title];
}

#pragma mark - # Getter
- (IMSearchController *)searchController
{
    if (!_searchController) {
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

- (IMAddMenuView *)addMenuView
{
    if (!_addMenuView) {
        _addMenuView = [[IMAddMenuView alloc] init];
        @weakify(self);
        [_addMenuView setItemSelectedAction:^(IMAddMenuView *addMenuView, IMAddMenuItem *item) {
            @strongify(self);
            if (item.className.length > 0) {
                id vc = [[NSClassFromString(item.className) alloc] init];
                if (vc) {
                   IMPushVC(vc);
                }
            }
            else {
                [IMUIUtility showAlertWithTitle:item.title message:@"功能暂未实现"];
            }
        }];
    }
    return _addMenuView;
}

@end
