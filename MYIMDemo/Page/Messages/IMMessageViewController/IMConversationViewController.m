//
//  IMMessagesViewController.m
//  IMXiniuCloud
//
//  Created by RPK on 2018/4/17.
//  Copyright © 2018年 EIMS. All rights reserved.
//




#import "IMAddContactsViewController.h"
#import "IMChatViewController.h"
#import "IMConversationAngel.h"
#import "IMConversationListTableViewCell.h"
#import "IMConversationModel.h"
#import "IMConversationViewController.h"
#import "IMEmojiGroup.h"
#import "IMImagePicker.h"
#import "IMLoginViewController.h"
#import "IMMessageModel.h"
#import "IMNetworkDetection.h"
#import "IMSearchMessageViewController.h"
#import "NSArray+Json.h"
#import "NSDate+Category.h"
#import "NSDictionary+Json.h"
#import "UIImage+Color.h"
#import "UIViewController+Category.h"
#import <AVFoundation/AVFoundation.h>
#import <YCMenuView.h>

@interface IMConversationViewController ()<UISearchControllerDelegate> {
    // V2.0版本 仅显示消息
    BOOL isOnlyMessage;
    // 是否在当前页面
    BOOL isCurrentPage;
    // 收到消息保存消息锁
    NSLock *receiverLock;
    dispatch_queue_t defaultQueue;
    dispatch_queue_t receiveQueue;
    // 选择的NSIndexPath
    NSIndexPath *selecteIndexPath;
    // 分段控制器选择的index
    NSInteger selectedIndex;
    // searchBar高度
    CGFloat searchBarHeight;
}

@property (nonatomic, strong) UITableView        *tableView;
// 搜索视图
@property (nonatomic, strong) UIView             *headerView;
// 无网络或者无法连接网络的情况
@property (nonatomic, strong) UIView             *networkTips;
@property (nonatomic, strong) UILabel            *titleLabel;
@property (nonatomic, strong) UIImageView        *tipsImageView;
@property (nonatomic, strong) UISearchController *searchViewCtrl;
@property (nonatomic, strong) IMSearchMessageViewController *searchCtrl;

// 收到的json消息
@property (nonatomic, strong) NSString           *receiveJson;
// 记录正在聊天的会话
@property (nonatomic, strong) NSString           *conversationId;
// 未读消息
@property (nonatomic, assign) NSInteger          badgeNumber;
// 分段控制器数据源menu
@property (nonatomic, strong) NSMutableArray     *menuDataSource;
/// 列表数据及控制中心
@property (nonatomic, strong) IMConversationAngel *listAngel;
@end

@implementation IMConversationViewController

- (instancetype)init{
    self = [super init];
    if (self) {
        initTabBarItem(self.tabBarItem, @"消息", @"tabbar_mainframe", @"tabbar_mainframeHL");
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self networkConnectionDetection];
    isCurrentPage = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    isCurrentPage = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isOnlyMessage  = YES;
    receiverLock   = [NSLock new];
    defaultQueue   = dispatch_queue_create("defaultQueue", NULL);
    receiveQueue   = dispatch_queue_create("receiveQueue", NULL);
    [self addNotification];
    [self addNavItem];
    
    @weakify(self);
    [KIMXMPPHelper setChangeAvatarPhoto:^{
        @strongify(self);
        [self addNavItem];
    }];
}

- (void)im_layoutNavigation{
    self.title = KIMXMPPHelper.userHelper.user.username;
    self.navigationController.tabBarItem.title = @"消息";
}

- (void)im_getNewData{
    [self getConversationListWithConversationId:@"-1"];
}

- (void)addNavItem{
    @weakify(self);
    [[IMUserHelper sharedHelper].user setAvatar:[KIMXMPPHelper myAvatar]];
    UIImage *img = [IMUserHelper sharedHelper].user.avatar;
    img = [[UIImage imageWithClipImage:img] drawWithNewImageSize:CGSizeMake(35, 35)];
    img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addLeftBarButtonWithImage:img actionBlick:^{
        //  修改头像
        [[[IMImagePicker alloc] init] selectPhotoMaxImagesCount:1 action:^(NSArray<UIImage *> * _Nonnull photos, NSArray * _Nonnull assets, BOOL isSelectOriginalPhoto) {
            if (photos.count > 0) {
                [KIMXMPPHelper updateMyAvatar:photos.firstObject];
            }
        }];
    }];
    [self addRightBarButtonWithImage:[UIImage imageMenuAdd] actionBlick:^{
        @strongify(self);
        //  按钮点击
        [self barItemAction];
    }];
}

- (void)im_addSubViews{
    //  添加所有数据
    [self addAllDataSource];
    self.isExtendLayout = NO;
    CGFloat systemVersion = [UIDevice currentSystemVersion].doubleValue;
    // iOS 11以前搜索框的高度是44 iOS 11及以后的高度是56
    searchBarHeight = systemVersion < 11.0 ? 44 : 56;
    
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
    [_searchCtrl.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    _networkTips = [[UIView alloc] initWithFrame:CGRectZero];
    _networkTips.backgroundColor = [UIColor colorWithRed:254/255. green:214/255. blue:216/255. alpha:1];
    [_headerView addSubview:_networkTips];
    
    _tipsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(22, 12, 20, 20)];
    [_networkTips addSubview:_tipsImageView];
    
    _titleLabel              = [[UILabel alloc] initWithFrame:CGRectMake(_tipsImageView.maxX + 15, _tipsImageView.mj_y, IMSCREEN_WIDTH - 22 - 10 - 20 - 15, 20)];
    _titleLabel.textColor    = [UIColor darkGrayColor];
    _titleLabel.font         = [UIFont systemFontOfSize:14];
    [_networkTips addSubview:_titleLabel];
    
    self.tableView                              = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor              = [UIColor colorGrayBG];
    self.tableView.separatorStyle               = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight           = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.tableHeaderView               = _headerView;
    self.tableView.tableFooterView              = [UIView new];
    [self.tableView setSectionIndexColor:[UIColor colorBlackForNavBar]];
    [self.tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    @weakify(self);
    self.listAngel = [[IMConversationAngel alloc] initWithHostView:self.tableView pushAction:^(__kindof UIViewController * _Nonnull vc) {
        @strongify(self);
        IMPushVC(vc);
    }];
    [self.listAngel setDeleteAction:^(__kindof NSIndexPath * _Nonnull indexPath) {
        IMConversationHelper *helper = [IMConversationHelper sharedConversationHelper];
        IMConversationModel *model = [[helper conversationData] zh_objectOfIndex:indexPath.row];
        //  删除指定的会话数据
        [[IMConversationHelper sharedConversationHelper] deleteConversationByConversationId:model.conversationId];
    }];
}

//  添加通知
- (void)addNotification{
    //  消息对话通知
    [IMNotificationCenter addObserver:self selector:@selector(conversationCommonNotification:) name:kConversationCommonNot object:nil];
    @weakify(self);
    [[IMConversationHelper sharedConversationHelper] addDataChangedNotificationObserver:self usingBlock:^(NSArray * _Nonnull conversationData, NSInteger conversationCount) {
        @strongify(self);
        [self.listAngel resetListWithContactsData:conversationData];
        [self.tableView reloadData];
    }];
}

- (void)addAllDataSource{
    // 创建YCMenuAction
    kWeakSelf;
    YCMenuAction *action = [YCMenuAction actionWithTitle:@"发起群聊" image:[UIImage imageMenuQunLiao] handler:^(YCMenuAction *action) {
        [SVProgressHUD showInfoWithStatus:@"功能尚未实现"];
        [SVProgressHUD dismissWithDelay:2];
    }];
    YCMenuAction *action1 = [YCMenuAction actionWithTitle:@"添加朋友" image:[UIImage imageMenuAddFriends] handler:^(YCMenuAction *action) {
        IMAddContactsViewController *vc = [[IMAddContactsViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    YCMenuAction *action2 = [YCMenuAction actionWithTitle:@"扫一扫" image:[UIImage imageMenuScan] handler:^(YCMenuAction *action) {
        [SVProgressHUD showInfoWithStatus:@"功能尚未实现"];
        [SVProgressHUD dismissWithDelay:2];
    }];
    
    YCMenuAction *action3 = [YCMenuAction actionWithTitle:@"退出" image:[UIImage imageMenuExit] handler:^(YCMenuAction *action) {
        [KIMXMPPHelper logOut];
        //  重置根视图
        [self restoreRootViewController:[[IMLoginViewController alloc] init]];
    }];
    self.menuDataSource = @[action,action1,action2,action3].mutableCopy;
}

- (void)conversationCommonNotification:(NSNotification *)notification{
    NSDictionary *notInfo = notification.userInfo;
    IMConversationCommonNotification notType = [notInfo[@"notType"] integerValue];
    switch (notType) {
        case IMConversationCommonNotificationMail:
//            [self receiveMailMessageDictionary:notInfo];
            break;
        case IMConversationCommonNotificationUpdateBedgeNumber:
            [self updateSelecteRowBadgeNumber:notInfo[@"conversationId"]];
            break;
        case IMConversationCommonNotificationReceiveMessage:
            [self receiveConversationMessage:notInfo[@"json"]];
            break;
        case IMConversationCommonNotificationNetworkConnectionStatus:
            [self networkDisconnection];
            break;
        case IMConversationCommonNotificationNetworkStatus:
            [self networkConnectionDetection];
            break;
        case IMConversationCommonNotificationEnterForeground:
            [self getConversationListWithConversationId:@"-1"];
            break;
        default:
            break;
    }
}

//  更新红点
- (void)updateSelecteRowBadgeNumber:(NSString *)conversationId
{
    /*
    if (_dataSource.count > 1)
    {
        kWeakSelf;
        [self.dataSource enumerateObjectsUsingBlock:^(IMConversationModel *converModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([converModel.conversationId isEqualToString:conversationId]) {
                converModel.badgeNumber           = 0;
                
                [weakSelf.dataSource replaceObjectAtIndex:idx withObject:converModel];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                });
                *stop = YES;
            }
        }];
    }
     */
}

// 网络连接检测
- (void)networkConnectionDetection{
    BOOL available = [[IMNetworkDetection shareInstance] checkNetCanUse];
    if (!available){
        _headerView.frame    = CGRectMake(0, 0, IMSCREEN_WIDTH, searchBarHeight+44);
        _networkTips.frame   = CGRectMake(0, _searchCtrl.searchBar.height, IMSCREEN_HEIGHT, 44);
        _titleLabel.text     = @"请检查你的网络，当前网络不可用";
        _tipsImageView.image = [UIImage imageMessageSendFailure];
    }
    else{
        _headerView.frame    = CGRectMake(0, 0, IMSCREEN_WIDTH, searchBarHeight);
        _networkTips.frame   = CGRectZero;
        _titleLabel.text     = @"";
        _tipsImageView.image = nil;
    }
    _tableView.tableHeaderView = _headerView;
}

// 无网络连接
- (void)networkDisconnection
{
    _headerView.frame          = CGRectMake(0, 0, IMSCREEN_WIDTH, searchBarHeight+44);
    _networkTips.frame         = CGRectMake(0, _searchCtrl.searchBar.height, IMSCREEN_HEIGHT, 44);
    _titleLabel.text           = @"请检查你的网络，无网络连接";
    _tipsImageView.image       = [UIImage imageMessageSendFailure];
    _tableView.tableHeaderView = _headerView;
}

//  更新标题
- (void)updateTitle {
    // 更新未读数量
    if (_badgeNumber){
        self.navigationItem.title  = [NSString stringWithFormat:@"消息(%ld)", (long)_badgeNumber];
    }
    else{
        self.navigationItem.title = @"消息";
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSString stringWithFormat:@"%ld", (long)_badgeNumber] forKey:@"badgeNumber"];
    
    [IMNotificationCenter postNotificationName:@"updateBadgeNumber" object:nil userInfo:dic];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:_badgeNumber];
    
}

//  导航栏按钮点击
- (void)barItemAction{
   
    //  创建YCMenuView(根据关联点或者关联视图)
    YCMenuView *view = [YCMenuView menuWithActions:self.menuDataSource width:140 relyonView:self.navigationItem.rightBarButtonItem];
    view.menuColor = [UIColor colorBlackBG];
    view.separatorColor = [UIColor colorGrayLine];
    view.maxDisplayCount = 5;
    view.offset = 0;
    view.textColor = [UIColor whiteColor];
    view.textFont = [UIFont boldSystemFontOfSize:16];
    view.menuCellHeight = 60;
    view.dismissOnselected = YES;
    view.dismissOnTouchOutside = YES;
    // 显示
    [view show];
}

#pragma mark - 收到IM消息
- (void)receiveConversationMessage:(NSString *)jsonStr{
    if ([jsonStr isEqualToString:@"001cb8ed56694183c520ca087b5940e2"] || !jsonStr.length || !jsonStr) {
        // 更新未读消息
        if (isCurrentPage) {
            [self getConversationListWithConversationId:@"-1"];
        }
        return;
    }
    
    kWeakSelf
    dispatch_async(receiveQueue, ^{
        
        [receiverLock lock];
        
        AudioServicesPlaySystemSound(1007);                     // 提示音
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);   // 震动
        
        weakSelf.receiveJson   = [NSString stringWithFormat:@"%@", jsonStr];
        
        NSDictionary *dic      = [NSDictionary dictionaryWithJsonString:weakSelf.receiveJson];
        NSDictionary *message  = [NSDictionary dictionaryWithDictionary:dic[msg_key]];
        
        IMMessageModel *messageModel = [IMMessageModel new];
        messageModel.content   = message[msg_content_key];
        messageModel.messageId = message[msg_id_key];
        messageModel.msgType   = [message[msg_type_key]integerValue];
        
        NSString *lastConvId   = dic[conversation_id_key];
        if ([message[msg_type_key]integerValue] == IMMessageTypeImage)
        {
            [weakSelf saveReceivedMessageWithMsgJson:weakSelf.receiveJson cellHeight:-1 messageSize:CGSizeMake(-1, -1) lastConverId:lastConvId messageDic:message imageData:nil];
        }
        else
        {
            [messageModel messageProcessingWithFinishedCalculate:^(CGFloat rowHeight, CGSize messageSize, BOOL complete) {
                [weakSelf saveReceivedMessageWithMsgJson:weakSelf.receiveJson cellHeight:rowHeight messageSize:messageSize lastConverId:lastConvId messageDic:message imageData:nil];
            }];
        }
        
        [receiverLock unlock];
    });
}

/**
 保存收到的消息
 
 @param messageJson 消息json
 @param cellHeight 行高
 @param messageSize 消息size
 @param lastConverId 上一次选择的会话id
 @param messageDic 消息字典
 @param imageData 图片数据
 */
- (void)saveReceivedMessageWithMsgJson:(NSString *)messageJson
                            cellHeight:(CGFloat)cellHeight
                           messageSize:(CGSize)messageSize
                          lastConverId:(NSString *)lastConverId
                            messageDic:(NSDictionary *)messageDic
                             imageData:(NSData *)imageData
{
    
}

- (void)getConversationListWithConversationId:(NSString *)conversationId{
    [self.listAngel resetListWithContactsData:[IMConversationHelper sharedConversationHelper].conversationData];
    [self.tableView reloadData];
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
    [self getConversationListWithConversationId:@"-1"];
}

@end


@implementation IMConversationViewController(Class)
+ (IMBaseNavigationController *)navMessagesVc {
    IMBaseNavigationController *navC = [[IMBaseNavigationController alloc] initWithRootViewController:[[[self class] alloc] init]];
    return navC;
}
@end
