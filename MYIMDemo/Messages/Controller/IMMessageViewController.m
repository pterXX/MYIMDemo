//
//  IMMessagesViewController.m
//  IMXiniuCloud
//
//  Created by RPK on 2018/4/17.
//  Copyright © 2018年 EIMS. All rights reserved.
//

#import "IMMessageViewController.h"

#import "NSArray+Json.h"
#import "UIImage+Color.h"
#import "NSDate+IMCategory.h"
#import "NSDictionary+Json.h"
#import "UIViewController+IMCategory.h"

#import "IMEmojiGroup.h"
#import "IMMessageModel.h"
#import "IMNetworkDetection.h"
#import "IMConversationModel.h"
#import "IMChatViewController.h"
#import "IMMessagesListTableViewCell.h"
#import "IMSearchMessageViewController.h"
#import <AVFoundation/AVFoundation.h>


@interface IMMessageViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate> {
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
@property (nonatomic, strong) UIView             *titleView;
@property (nonatomic, strong) UIView             *bottomLine;
// 收到的json消息
@property (nonatomic, strong) NSString           *receiveJson;
// 记录正在聊天的会话
@property (nonatomic, strong) NSString           *conversationId;
// 未读消息
@property (nonatomic, assign) NSInteger          badgeNumber;
// 数据源
@property (nonatomic, strong) NSMutableArray     *dataSource;
// 分段控制器数据源
@property (nonatomic, strong) NSMutableArray     *segmentDataSource;

@end

@implementation IMMessageViewController

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self networkConnectionDetection];
    
    if (KIsRefreshMessageView) {
        _badgeNumber = 0;
        [self getConversationListWithConversationId:@"-1"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isRefreshMessageView"];
    }
    
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
}

- (void)im_layoutNavigation{
      self.title = @"消息";
}

- (void)im_addSubViews{
    CGFloat systemVersion = [UIDevice currentSystemVersion].doubleValue;
    // iOS 11以前搜索框的高度是44 iOS 11及以后的高度是56
    searchBarHeight = systemVersion < 11.0 ? 44 : 56;
    _segmentDataSource = [NSMutableArray arrayWithObjects:@"消息", @"访客", nil];
    
    _titleView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IMSCREEN_WIDTH, 44)];
    _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(IMSCREEN_WIDTH/4., 42, 40, 2)];
    _bottomLine.center = CGPointMake(IMSCREEN_WIDTH/4., 42);
    _bottomLine.backgroundColor = kSegmentItemColor;
    [_titleView addSubview:_bottomLine];
    
    self.isExtendLayout = NO;
    
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
    
    _networkTips = [[UIView alloc] initWithFrame:CGRectZero];
    _networkTips.backgroundColor = [UIColor colorWithRed:254/255. green:214/255. blue:216/255. alpha:1];
    [_headerView addSubview:_networkTips];
    
    
    _tipsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(22, 12, 20, 20)];
    [_networkTips addSubview:_tipsImageView];
    
    _titleLabel              = [[UILabel alloc] initWithFrame:CGRectMake(_tipsImageView.maxX + 15, _tipsImageView.mj_y, IMSCREEN_WIDTH - 22 - 10 - 20 - 15, 20)];
    _titleLabel.textColor    = [UIColor darkGrayColor];
    _titleLabel.font         = [UIFont systemFontOfSize:14];
    [_networkTips addSubview:_titleLabel];
    
    self.tableView.tableHeaderView = _headerView;
    
    [IMNotificationCenter addObserver:self selector:@selector(conversationCommonNotification:) name:kConversationCommonNot object:nil];
    // 设置自己的头像
    [[IMAppDefaultUtil sharedInstance] setUserAvatar:@"http://cname-yunke.shovesoft.com/group1/M00/00/1A/CgAHEVuMyv6AKj6uAABukEJ7t3I575.png"];
    [self getConversationListWithConversationId:@"-1"];
}

- (void)conversationCommonNotification:(NSNotification *)notification
{
    NSDictionary *notInfo = notification.userInfo;
    IMConversationCommonNotification notType = [notInfo[@"notType"] integerValue];
    switch (notType) {
            case IMConversationCommonNotificationMail:
            [self receiveMailMessageDictionary:notInfo];
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

- (void)updateSelecteRowBadgeNumber:(NSString *)conversationId
{
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
}

// 网络连接检测
- (void)networkConnectionDetection
{
    BOOL available = [[IMNetworkDetection shareInstance] checkNetCanUse];
    if (!available)
    {
        _headerView.frame    = CGRectMake(0, 0, IMSCREEN_WIDTH, searchBarHeight+44);
        _networkTips.frame   = CGRectMake(0, _searchCtrl.searchBar.height, IMSCREEN_HEIGHT, 44);
        _titleLabel.text     = @"请检查你的网络，当前网络不可用";
        _tipsImageView.image = [UIImage imageMessageSendFailure];
    }
    else
    {
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

- (void)updateTitle {
    // 更新未读数量
    if (_badgeNumber)
    {
        self.navigationItem.title  = [NSString stringWithFormat:@"消息(%ld)", (long)_badgeNumber];
    }
    else
    {
        self.navigationItem.title = @"消息";
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSString stringWithFormat:@"%ld", (long)_badgeNumber] forKey:@"badgeNumber"];
    
    [IMNotificationCenter postNotificationName:@"updateBadgeNumber" object:nil userInfo:dic];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:_badgeNumber];
    
}

#pragma mark 收到邮件消息
- (void)receiveMailMessageDictionary:(NSDictionary *)dictionary
{
    NSString *covId = dictionary[@"converId"];
    NSString *msgId = dictionary[@"messageId"];
    BOOL isCompany  = [dictionary[@"isCompany"] boolValue];
    
    // 非发送邮箱消息，设置铃声及震动（-1:发送邮件  -2:删除邮件   -3:接收邮件）
    if (![msgId isEqualToString:@"-1"] &&
        ![msgId isEqualToString:@"-2"] && isCompany) {
        // 提示音
        AudioServicesPlaySystemSound(1007);
        // 震动
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    
    if ([msgId isEqualToString:@"-2"] || [msgId isEqualToString:@"-3"]) {
        msgId = @"-1";
    }
    
    if (isCurrentPage) {
        [self getConversationListWithConversationId:covId];
    }else {
        // 先刷新未读标记
        kWeakSelf
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf updateTitle];
        });
        // 把消息推到聊天页面上显示出来
        NSDictionary *messageNot = @{@"conversationId":covId, @"messageId":msgId};
        [IMNotificationCenter postNotificationName:@"newMessage" object:nil userInfo:messageNot];
    }
}

#pragma mark - 收到IM消息
- (void)receiveConversationMessage:(NSString *)jsonStr
{
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

- (void)getConversationListWithConversationId:(NSString *)conversationId
{
    kWeakSelf;
    [self.dataSource removeAllObjects];
    NSError *error = nil;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"conversationList" ofType:nil];
    NSString *jsonStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    if (!error) {
        NSArray *messageList = [NSArray arrayWithJsonStr:jsonStr];
        [messageList enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            IMConversationModel *model = [IMConversationModel new];
            model.conversationId      = obj[conversation_id_key];
            model.conversationName    = obj[conversation_name_key];
            model.badgeNumber         = [obj[unreead_num_key] intValue];
            model.headImage           = obj[head_img_key];
            model.toUserId            = obj[to_user_id_key];
            
            NSDictionary *msgdic      = obj[msg_key];
            
            IMMessageModel *message    = [IMMessageModel new];
            message.recvTime          = msgdic[send_time_key];
            message.content           = msgdic[msg_content_key];
            message.msgType           = [msgdic[msg_type_key]integerValue];
            message.messageSendStatus = [msgdic[send_status_key] integerValue];
            model.message             = message;
            [weakSelf.dataSource addObject:model];
        }];
    }
    
    [self updateTitle];
    [self.tableView reloadData];
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        action.backgroundColor = [UIColor redColor];
        
    }];
    
    return @[action];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    selecteIndexPath                    = indexPath;
    
    IMConversationModel *conversation    = self.dataSource[indexPath.row];
    _conversationId                     = conversation.conversationId;
    
    IMChatViewController *chatCtrl       = [IMChatViewController new];
    chatCtrl.title                      = conversation.conversationName;
    chatCtrl.hidesBottomBarWhenPushed   = YES;
    chatCtrl.conversation               = conversation;
    
    chatCtrl.isConversationInto         = YES;
    
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
    [self getConversationListWithConversationId:@"-1"];
}



@end
