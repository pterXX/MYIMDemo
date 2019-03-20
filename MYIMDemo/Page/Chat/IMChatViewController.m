//
//  IMChatViewController.m
//  KXiniuCloud
//
//  Created by eims on 2018/5/8.
//  Copyright © 2018年 EIMS. All rights reserved.
//

#import "IMChatViewController.h"


#import <CoreAudio/CoreAudioTypes.h>
#import <AudioToolbox/AudioToolbox.h>

#import "NSArray+Json.h"
#import "NSDate+Category.h"
#import "NSDictionary+Json.h"
#import "NSString+Category.h"
#import "NSTextAttachment+Emoji.h"
#import "IMChatViewController+Image.h"
#import "IMChatViewController+Voice.h"

#import "IMPhoto.h"

#import "IMTextView.h"
#import "IMFileCache.h"
#import "IMPhotoBrowser.h"
#import "IMInputBoxView.h"
#import "IMMessageModel.h"
#import "IMFileManagement.h"
#import "IMInputBoxViewCtrl.h"
#import "IMConversationModel.h"
#import "IMPhotoPreviewModel.h"
#import "IMVideoViewController.h"
#import "IMInputBoxRecorderView.h"
#import "IMChatTextTableViewCell.h"
#import "IMChatMailTableViewCell.h"
#import "IMChatVoiceTableViewCell.h"
#import "IMChatImageTableViewCell.h"
#import "IMChatVideoTableViewCell.h"
#import "TZImagePickerController.h"

@interface IMChatViewController () <IMInputBoxViewCtrlDelegate, TZImagePickerControllerDelegate, IMPhotoBrowserDelegate, IMPhotoBrowserDatasource, UITableViewDelegate, UITableViewDataSource>
{
    // 点击的图片
    IMPhotoPreviewModel *crrentTapPhoto;
    // 可以看见的图片预览视图模型
    NSMutableArray     *visiblePhotoPreviews;
    // 默认串行队列
    dispatch_queue_t   defaultQueue;
    // 更新消息发送状态队列
    dispatch_queue_t   updateStatusQueue;
    // 收到消息串行队列
    dispatch_queue_t   receiveMessageQueue;
    // 发送消息锁
    NSLock             *sendMessage;
    // 未读消息数
    NSInteger          unreadMsgCount;
    // 收到消息锁
    NSLock             *reveiceMessageLock;
    
    UIWindow           *window;
    // 是从其他页面返回
    BOOL               isBack;
    // 第一次加载
    BOOL               isFirstLoad;
    BOOL               isAuthorized;
    BOOL               isTapListView;
    // 上一次重发的行号
    NSInteger          indexPathRow;
}

// 聊天记录中的图片或视频
@property (nonatomic, strong) NSMutableArray         *photos;

@property (nonatomic, strong) UITapGestureRecognizer *tapListView;
// 会话成员邮箱
@property (nonatomic, strong) NSArray                *toAddressArray;
// 返回按钮
@property (nonatomic, strong) UIButton               *backBut;
/**手机号*/
@property (nonatomic, strong) NSString               *phoneNumber;
// 输入框控制器
@property (nonatomic, strong) IMInputBoxViewCtrl      *inputBoxCtrl;

@property (nonatomic, strong) NSArray                *imageDatas;

@end


#define LIST_VIEW_FRAME
@implementation IMChatViewController

@synthesize backBut;

+ (CGRect)listViewCtrlWrthFrame{
    static CGRect frame;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        frame = CGRectMake(0, 0, IMSCREEN_WIDTH, IMSCREEN_HEIGHT - IMSTATUSBAR_NAVBAR_HEIGHT - IMTABBAR_HEIGHT);
    });
    return frame;
}

+ (CGRect)inputBoxViewCtrlWrthFrame{
    static CGRect frame;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGRect listViewFrame = [self listViewCtrlWrthFrame];
        frame = CGRectMake(0,listViewFrame.origin.y + listViewFrame.size.height, IMSCREEN_WIDTH, IMTABBAR_HEIGHT);
    });
    return frame;
}

- (void)setConversation:(IMConversationModel *)conversation {
    _conversation  = conversation;
    unreadMsgCount = conversation.badgeNumber;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.audioPlayer) {
        [self.audioPlayer stop];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (isBack) {
        [self updateViewFrame];
    }
    isBack = YES;
}

- (BOOL)prefersStatusBarHidden {
    [super prefersStatusBarHidden];
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self addObserver];
}

/**
 绘制导航栏
 */
- (void)im_layoutNavigation{
    backBut = [UIButton buttonWithType:UIButtonTypeCustom];
    backBut.frame = CGRectMake(0, 0, 80, 44);
    backBut.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    backBut.titleLabel.font = [UIFont systemFontOfSize:14];
    [backBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backBut setTitle:@"消息" forState:UIControlStateNormal];
    [backBut setImage:[UIImage imageNavBack] forState:UIControlStateNormal];
    [backBut addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    backBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBut];
}

/**
 添加子视图
 */
- (void)im_addSubViews{
    [IMNotificationCenter addObserver:self selector:@selector(updateRowHeight:) name:@"updateRowHeight" object:nil];
    [IMNotificationCenter postNotificationName:kConversationCommonNot object:nil userInfo:@{@"notType":@(IMConversationCommonNotificationUpdateBedgeNumber), @"conversationId":IMNoNilString(_conversation.chatToJid.user)}];
    
    self.listView                 = [[UITableView alloc] initWithFrame:[[self class] listViewCtrlWrthFrame] style:UITableViewStylePlain];
    self.listView.delegate        = self;
    self.listView.dataSource      = self;
    // 这行代码很重要，一定不能删，删了会导致隐藏键盘时cell闪烁
    self.listView.estimatedRowHeight = 0;
    self.listView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.listView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.listView.backgroundColor = KBGColor1;
    [self.view addSubview:self.listView];
    
    //  列表添加手势
    self.tapListView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapListViewAction:)];
    [self.listView addGestureRecognizer:_tapListView];
    
    [self.listView registerClass:[IMChatTextTableViewCell class] forCellReuseIdentifier:NSStringFromClass([IMChatTextTableViewCell class])];
    [self.listView registerClass:[IMChatMailTableViewCell class] forCellReuseIdentifier:NSStringFromClass([IMChatMailTableViewCell class])];
    [self.listView registerClass:[IMChatVoiceTableViewCell class] forCellReuseIdentifier:NSStringFromClass([IMChatVoiceTableViewCell class])];
    [self.listView registerClass:[IMChatImageTableViewCell class] forCellReuseIdentifier:NSStringFromClass([IMChatImageTableViewCell class])];
    [self.listView registerClass:[IMChatVideoTableViewCell class] forCellReuseIdentifier:NSStringFromClass([IMChatVideoTableViewCell class])];
    
    //  设置刷新控件
    MJRefreshGifHeader *headRefresh = [[MJRefreshGifHeader alloc] initWithFrame:CGRectZero];
    [headRefresh setImages:@[] forState:MJRefreshStateRefreshing];
    headRefresh.ignoredScrollViewContentInsetTop = 0;
    headRefresh.lastUpdatedTimeLabel.hidden = YES;
    headRefresh.stateLabel.hidden           = YES;
    [headRefresh setRefreshingTarget:self refreshingAction:@selector(pullDownLoadMoreData)];
    self.listView.mj_header                 = headRefresh;
    
    self.inputBoxCtrl = [[IMInputBoxViewCtrl alloc] initWithFrame:[[self class] inputBoxViewCtrlWrthFrame]];
    self.inputBoxCtrl.delegate = self;
    [self.view addSubview:self.inputBoxCtrl];
    
    [self.inputBoxCtrl.inputBox addObserver:self forKeyPath:@"recordState" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    window = [UIApplication sharedApplication].keyWindow;
    [self.recordView updateState:IMInputBoxRecordStatusNone];
    [self.recordView setCenter:window.center];
    [window addSubview:self.recordView];
}

- (void)back:(UIButton *)sender {
    [IMNotificationCenter postNotificationName:@"chatBack" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initData {
    isAuthorized          = NO;
    _isEnterSend          = YES;
    indexPathRow          = -1;
    _lastPlayVoiceIndex   = -1;
    sendMessage           = [NSLock new];
    reveiceMessageLock    = [NSLock new];
    visiblePhotoPreviews  = [NSMutableArray array];
    defaultQueue          = dispatch_queue_create("defaultQueue", NULL);
    updateStatusQueue     = dispatch_queue_create("updateStatus", NULL);
    receiveMessageQueue   = dispatch_queue_create("receiveMessageQueue", NULL);
    
    isFirstLoad     = YES;
    _dataSource     = [NSMutableArray array];
    _allImageDatas  = [NSMutableArray array];
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"changeSelection"];
    
    [self initVoiceData];
    
    // 获取会话消息
    [self getMessagesDataWithMessageId:@"0"];
}

// 有未读消息时通知服务器，这些消息已被标记为已读
- (void)UpdateConversationState {
    // 有未读消息时通知服务器，这些消息已被标记为已读
    kWeakSelf
    dispatch_async(defaultQueue, ^{
        
        if (self->unreadMsgCount)
        {
            [weakSelf updateMessageReadState];
        }
    });
}

/**
 更新本地当前会话为已读消息
 */
- (void)updateMessageReadState {
    
}

/**
 下拉加载历史消息
 */
- (void)pullDownLoadMoreData
{
    // 不足20条消息，不支持下拉
    if (_dataSource.count >= 20)
    {
        isFirstLoad = NO;
        IMMessageModel *message = [_dataSource firstObject];
        [self getMessagesDataWithMessageId:message.messageId];
    }
    else {
        [self.listView.mj_header endRefreshing];
    }
}

/**
 根据 消息ID 分页加载数据
 */
- (void)getMessagesDataWithMessageId:(NSString *)messageId{
    NSArray *fetchedObjects = [KIMXMPPHelper fetchedMessagesOfJid:self.conversation.chatToJid];
    if (fetchedObjects != nil ) {
        [self.dataSource removeAllObjects];
        __block IMMessageModel *previousMessage = nil;
        __block NSInteger num = 0;
        @weakify(self);
        NSArray *array = [fetchedObjects zh_enumerateObjectsUsingBlock:^id(XMPPMessageArchiving_Message_CoreDataObject * obj) {
            @strongify(self);
            return  [IMMessageModel modelWithCoreDataObject:obj complete:^IMMessageModel * _Nonnull(IMMessageModel * _Nonnull objModel, XMPPMessageArchiving_Message_CoreDataObject * _Nonnull coreDataobj) {
                objModel.lastMessage     = previousMessage;
                NSTimeInterval prevTime = 0;
                NSTimeInterval lastTime = 0;
                if (objModel.direction == IMMessageSenderTypeSender) {
                    lastTime = [objModel.sendTime integerValue];
                }
                else {
                    lastTime = [objModel.recvTime integerValue];
                }
                
                if (previousMessage.direction == IMMessageSenderTypeSender) {
                    prevTime = [previousMessage.sendTime integerValue];
                }
                else {
                    prevTime = [previousMessage.recvTime integerValue];
                }
                
                BOOL isShowTime       = [NSDate showTimeWithPreviousTime:prevTime lastTime:lastTime];
                
                objModel.showMessageTime = isShowTime;
                previousMessage       = objModel;
                
                if (objModel.msgType == IMMessageTypeImage && objModel.cellHeight == -1) {
                    CGFloat showTimeHeight = isShowTime ? SHOW_MESSAGE_TIME_HEIGHT : 0;
                    [objModel messageProcessingWithFinishedCalculate:^(CGFloat rowHeight, CGSize messageSize, BOOL complete) { }];
                    objModel.estimateHeight = 200 + showTimeHeight;
                    objModel.estimateSize   = CGSizeMake(102, objModel.estimateHeight - showTimeHeight - 20);
                }
                else {
                    [objModel messageProcessingWithFinishedCalculate:^(CGFloat rowHeight, CGSize messageSize, BOOL complete) { }];
                }
                
                if (objModel.msgType == IMMessageTypeImage){
                    IMPhotoPreviewModel *model = [IMPhotoPreviewModel new];
                    model.messageId    = objModel.messageId;
                    model.content      = objModel.fileData;
                    if (isFirstLoad){
                        [self.allImageDatas addObject:model];
                    }
                    else{
                        [self.allImageDatas insertObject:model atIndex:num];
                        num ++;
                    }
                }
                return objModel;
            }];
        }];
        [self.dataSource addObjectsFromArray:array];
    }
    [self.listView reloadData];
    [self scrollTableViewBottom];
}

/**
 监控消息接收
 */
- (void)addObserver{
    @weakify(self);
    [KIMXMPPHelper addChatDidSendMessageNotificationObserver:self usingBlock:^{
        @strongify(self);
        [self addConversation];
    }];
    
    [KIMXMPPHelper addChatDidFailToSendMessageNotificationObserver:self usingBlock:^{
        
    }];
    
    [KIMXMPPHelper addChatUserDidReceiveMessageNotificationObserver:self userJid:self.conversation.chatToJid usingBlock:^{
        @strongify(self);
        [self getMessagesDataWithMessageId:@"0"];
        [self addConversation];
    }];
}

/**
 添加到会话列表
 */
- (void)addConversation{
    self.conversation.message = [self lastMessage];
    //  只有发送了消息才会记录列表
    BOOL ok = [[IMConversationHelper sharedConversationHelper] addConversation:self.conversation];
    if (!ok) NSLog(@"================>  插入会话数据失败");
}

/**
 发送消息
 
 @param content 消息内容 文本消息content为文字，图片、语音content为NSData转成的字符串
 @param cellHeight 行高
 @param messageSize 消息控件大小
 @param messageType 消息类型
 @param filePath 图片、视频、音频路径,其他消息传nil
 @param messageModel 当前的消息model
 @param saveResult 保存消息回调
 */
- (void)saveMessageWithContent:(NSString *)content
                    cellHeight:(CGFloat)cellHeight
                   messageSize:(CGSize)messageSize
                   messageType:(IMMessageType)messageType
                      filePath:(NSString *)filePath
                  messageModel:(IMMessageModel *)messageModel
                     indexPath:(NSIndexPath *)indexPath
                    saveResult:(void(^)(BOOL isSuccess, NSDictionary *jsonDic, NSString *localMsgId))saveResult
{
    
}

/**
 发送消息
 
 @param jsonStr 消息json字符串
 @param localMessageId 本地消息id
 @param indexPath 当条消息所在行数据
 */
- (void)sendMessageWithJsonStr:(NSString *)jsonStr
                localMessageId:(NSString *)localMessageId
                     indexPath:(NSIndexPath *)indexPath
{
    if (jsonStr) {
        
    }
}

/**
 更新本地消息发送状态
 
 @param srcId 本地消息id
 @param destId 服务器返回消息id
 @param sendState 消息状态，0：失败，1：成功 2:发送中
 */
- (void)updateDatabaseMessageWithSrcId:(NSString *)srcId
                                destId:(NSString *)destId
                             sendState:(int)sendState
{
    
}

- (void)updateRowHeight:(NSNotification *)notification {
    
    NSString *messageId = [NSString stringWithFormat:@"%@",notification.userInfo[@"messageId"]];
    CGFloat cellHeight  = [notification.userInfo[@"cellHeight"] floatValue];
    CGSize  messageSize = [notification.userInfo[@"messageSize"] CGSizeValue];
    
    kWeakSelf;
    NSArray *dataArray  = [NSArray arrayWithArray:self.dataSource];
    NSInteger maxCount = self.dataSource.count - 1;
    dataArray = [[dataArray reverseObjectEnumerator] allObjects];
    
    [dataArray enumerateObjectsUsingBlock:^(IMMessageModel *messageModel, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([messageId isEqualToString:messageModel.messageId]) {
            messageModel.updatedRowHeight = YES;
            messageModel.cellHeight  = cellHeight;
            messageModel.messageSize = messageSize;
            messageModel.isDelayShowSendStatus = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.dataSource replaceObjectAtIndex:maxCount - idx withObject:messageModel];
                [weakSelf.listView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:maxCount - idx inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                [weakSelf scrollTableViewBottom];
            });
        }
        *stop = YES;
    }];
}


/**
 更新Cell视图消息发送状态
 
 @param sendState 发送状态
 @param indexPath 列表索引
 @param localMessageId 本地消息id
 @param serversMsgId 服务端消息id
 */
- (void)updateMessageSendStatus:(IMMessageSendStatus)sendState
                      indexPath:(NSIndexPath *)indexPath
                 localMessageId:(NSString *)localMessageId
                   serversMsgId:(NSString *)serversMsgId
{
    
    kWeakSelf
    // 如果还没有绘制完成，先等绘制完成再做更新处理
    while (self.dataSource.count <= indexPath.row) {
        [NSThread sleepForTimeInterval:0.0001];
    }
    // 服务端消息id代替本地消息id
    if (localMessageId != serversMsgId) {
        NSArray *arr = [NSArray arrayWithArray:self.allImageDatas];
        [arr enumerateObjectsUsingBlock:^(IMPhotoPreviewModel *photoModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([photoModel.messageId isEqualToString:localMessageId]) {
                photoModel.messageId = serversMsgId.length ? serversMsgId : photoModel.messageId;
                [weakSelf.allImageDatas replaceObjectAtIndex:idx withObject:photoModel];
                *stop = YES;
            }
        }];
    }
    
    IMMessageModel *messageModel = weakSelf.dataSource[indexPath.row];
    if ([messageModel.messageId isEqualToString:localMessageId]) {
        
        messageModel.messageId = serversMsgId.length ? serversMsgId : messageModel.messageId;
        
        messageModel.aotoResend            = NO;
        messageModel.messageSendStatus     = sendState;
        messageModel.isDelayShowSendStatus = YES;
        [weakSelf.dataSource replaceObjectAtIndex:indexPath.row withObject:messageModel];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.listView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [weakSelf scrollTableViewBottom];
        });
        
    }
    else {
        
        NSArray *dataArrary = [NSArray arrayWithArray:self.dataSource];
        dataArrary = [[dataArrary reverseObjectEnumerator] allObjects];
        [dataArrary enumerateObjectsUsingBlock:^(IMMessageModel *messageModel, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([messageModel.messageId isEqualToString:localMessageId]) {
                messageModel.messageId = serversMsgId.length ? serversMsgId : messageModel.messageId;
                
                messageModel.messageSendStatus = sendState;
                messageModel.aotoResend        = NO;
                [weakSelf.dataSource replaceObjectAtIndex:idx withObject:messageModel];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSIndexPath *index = [NSIndexPath indexPathForRow:idx inSection:0];
                    [weakSelf.listView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
                    [weakSelf scrollTableViewBottom];
                });
                *stop = YES;
            }
        }];
    }
}


/**
 添加消息
 
 @param model 当前的消息model
 */
- (void)addMessage:(IMMessageModel *)model
{
    if (model.msgType == IMMessageTypeImage || model.msgType == IMMessageTypeVideo)
    {
        IMPhotoPreviewModel *photoModel = [IMPhotoPreviewModel new];
        photoModel.content   =  model.fileData ? model.fileData : model.content;
        photoModel.videoUrl  = model.content;
        photoModel.messageId = model.messageId;
        [self.allImageDatas addObject:photoModel];
    }
    
    kWeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        model.isDelayShowSendStatus = YES;
        [weakSelf.dataSource addObject:model];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:weakSelf.dataSource.count - 1 inSection:0];
        [weakSelf.listView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:0];
        
        [weakSelf scrollTableViewBottom];
    });
}

- (IMMessageModel *)lastMessage {
    return [_dataSource lastObject];
}

/**
 移除最后一条消息
 
 @param message 消息
 */
- (void)removeLastMessage:(IMMessageModel *)message
{
    if (_dataSource.count >= 1)
    {
        if (message)
        {
            if ([_dataSource containsObject:message])
            {
                [_dataSource removeObject:message];
            }
            else
            {
                [_dataSource removeLastObject];
            }
        }
        else
        {
            [_dataSource removeLastObject];
        }
        
        [self.listView reloadData];
        [self scrollTableViewBottom];
    }
}

- (void)reloadData {
    [self.listView reloadData];
    [self scrollTableViewBottom];
}

- (void)intoMailDetailWithMessageModel:(IMMessageModel *)messageModel {
    
}

- (void)scrollTableViewBottom
{
    if (_dataSource.count > 0)
    {
        [_listView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_dataSource.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

- (void)tapListViewAction:(UIGestureRecognizer *)gesture {
    isTapListView = YES;
    [self updateViewFrame];
}

#pragma mark - UITableViewDataSource UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    IMMessageModel *messageModel = self.dataSource[indexPath.row];
    
    if (messageModel.msgType == IMMessageTypeVoice && messageModel.showMessageTime) {
        return 90;
    }
    else if (messageModel.msgType == IMMessageTypeImage && (messageModel.cellHeight == -1 || messageModel.cellHeight == 0)) {
        // 预估的高度
        return messageModel.estimateHeight;
    }
    return messageModel.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMMessageModel *messageModel = self.dataSource[indexPath.row];
    id cell = [tableView dequeueReusableCellWithIdentifier:messageModel.cellIdendtifier forIndexPath:indexPath];
    [cell setDelegate:self];
    [cell setIndexPath:indexPath];
    [cell setConversation:_conversation];
    [cell setMessageModel:messageModel];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self scrollTableViewBottom];
    // 取消全选或取消选择
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"changeSelection"];
    if (dic && [dic[@"change"] boolValue]) {
        NSIndexPath *changeSelectIndex = [NSIndexPath indexPathForRow:[dic[@"row"] integerValue] inSection:0];
        IMChatTextTableViewCell *cell = (IMChatTextTableViewCell *)[tableView cellForRowAtIndexPath:changeSelectIndex];
        cell.textView.selectedRange = NSMakeRange(cell.textView.attributedText.length, 0);
        [cell.textView resignFirstResponder];
    }
    
    [self updateViewFrame];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [SDWebImageManager.sharedManager cancelAll];
    [SDWebImageManager.sharedManager.imageCache clearMemory];
    
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"changeSelection"];
    if (dic && [dic[@"change"] boolValue]) {
        NSIndexPath *changeSelectIndex = [NSIndexPath indexPathForRow:[dic[@"row"] integerValue] inSection:0];
        IMChatTextTableViewCell *cell = (IMChatTextTableViewCell *)[self.listView cellForRowAtIndexPath:changeSelectIndex];
        cell.textView.selectedRange = NSMakeRange(cell.textView.attributedText.length, 0);
        [cell.textView resignFirstResponder];
    }
    
    [self updateViewFrame];
}

#pragma mark - IMChatTableViewCellDelegate
/**
 点击头像
 
 @param tableViewCell 当条cell
 @param messageModel cell数据
 */
- (void)chatTableViewCell:(id)tableViewCell clickAvatarImageViewMessageModel:(IMMessageModel *)messageModel {
    
    [self updateViewFrame];
}

/**
 当发送失败时点击，发送状态展示视图
 
 @param tableViewCell 当前cell
 @param conversationModel 会话信息
 @param messageModel 消息
 */
- (void)chatTableViewCell:(IMChatTableViewCell *)tableViewCell clickResendMessageWithConversationModel:(IMConversationModel *)conversationModel messageModel:(IMMessageModel *)messageModel
{
    kWeakSelf
    if (messageModel.messageSendStatus == IMMessageSendStatusSendFailure) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"你是否需要重发此消息" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *resendAction = [UIAlertAction actionWithTitle:@"重发" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                       {
                                           [weakSelf jsonStrWithConversationModel:conversationModel
                                                                     messageModel:messageModel
                                                                        indexPath:[tableViewCell indexPath]
                                                                transformComplete:^(NSString *jsonStr)
                                            {
                                                [tableViewCell updateMessageSendState:IMMessageSendStatusSending
                                                                              jsonStr:jsonStr
                                                                       localMessageId:messageModel.messageId];
                                                
                                                [weakSelf sendMessageWithJsonStr:jsonStr
                                                                  localMessageId:messageModel.messageId
                                                                       indexPath:tableViewCell.indexPath];
                                            }];
                                       }];
        [alertController addAction:cancelAction];
        [alertController addAction:resendAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else {
        // 进入页面时需要发送处于正在发送的消息
        if (_isEnterSend) {
            
            [self jsonStrWithConversationModel:conversationModel
                                  messageModel:messageModel
                                     indexPath:[tableViewCell indexPath]
                             transformComplete:^(NSString *jsonStr)
             {
                 [weakSelf sendMessageWithJsonStr:jsonStr
                                   localMessageId:messageModel.messageId
                                        indexPath:tableViewCell.indexPath];
             }];
        }
    }
}

/**
 点击聊天背景
 
 @param tableViewCell 当前点击的cell
 @param messageModel 当前cell的数据
 */
- (void)chatTableViewCell:(id)tableViewCell clickBackgroudImageViewMessageModel:(IMMessageModel *)messageModel {
    
    [self updateViewFrame];
    switch (messageModel.msgType) {
        case IMMessageTypeNone:
            break;
        case IMMessageTypeText:
            break;
        case IMMessageTypeMail:
        {
            [self intoMailDetailWithMessageModel:messageModel];
        }
            break;
        case IMMessageTypeImage:
        {
            [self photoBrowserWithChatTableViewCell:tableViewCell messageModel:messageModel];
            
        }
            break;
        case IMMessageTypeVoice:
        {
            NSIndexPath *indexPath = [tableViewCell indexPath];
            // 第一次点击或者点击不同的cell是触发
            if (self.lastPlayVoiceIndex != indexPath.row) {
                [self playAudioWithTableViewCell:tableViewCell messageModel:messageModel];
                self.lastPlayVoiceIndex = indexPath.row;
            }
            else {
                [self.audioPlayer stop];
                [self.voiceImageView stopAnimating];
                self.lastPlayVoiceIndex = -1;
            }
        }
            
            break;
        case IMMessageTypeVideo:
        {
            [self photoBrowserWithChatTableViewCell:tableViewCell messageModel:messageModel];
        }
            break;
        default:
            break;
    }
}

/**
 回复邮件
 
 @param tableViewCell 点击的邮件属于那个cell
 @param messageModel cell数据
 */
- (void)chatTableViewCell:(id)tableViewCell replyMailMessageModel:(IMMessageModel *)messageModel {
    [self updateViewFrame];
    [self intoMailDetailWithMessageModel:messageModel];
}

/**
 回复全部
 
 @param tableViewCell 点击邮件属于那个cell
 @param messageModel cell数据
 */
- (void)chatTableViewCell:(id)tableViewCell replyAllMaillMessageModel:(IMMessageModel *)messageModel {
    [self updateViewFrame];
    [self intoMailDetailWithMessageModel:messageModel];
}

/**
 转发邮件
 
 @param tableViewCell 点击邮件属于那个cell
 @param messageModel cell数据
 */
- (void)chatTableViewCell:(id)tableViewCell transmitMailMessageModel:(IMMessageModel *)messageModel {
    [self updateViewFrame];
    [self intoMailDetailWithMessageModel:messageModel];
}

- (void)chatTableViewCell:(IMChatVoiceTableViewCell *)tableViewCell clickVoiceMessageMessageModel:(IMMessageModel *)messageModel {
    [self updateViewFrame];
}

/**
 更新视图frame
 */
- (void)updateViewFrame {
    
    [self.inputBoxCtrl resignFirstResponder];
    
    [UIView animateWithDuration:0.15 animations:^{
        
        CGRect listViewFrame = [[self class] listViewCtrlWrthFrame];
        CGFloat height = listViewFrame.size.height;
        
        if (self.inputBoxCtrl.inputBox.inputBoxStatus == IMInputBoxStatusShowVoice) {
            height = IMSCREEN_HEIGHT - IMSTATUSBAR_NAVBAR_HEIGHT - self.inputBoxCtrl.inputBox.curHeight;
        }
        
        if (height != self.listView.mj_h) {
            self.listView.frame = CGRectMake(0, listViewFrame.origin.y, IMSCREEN_WIDTH, height);
            if (self->isTapListView) {
                [self scrollTableViewBottom];
                self->isTapListView = NO;
            }
        }
        
        CGFloat inputBoxHeight = self.inputBoxCtrl.inputBox.curHeight + IMSAFEAREA_INSETS_BOTTOM;
        if (inputBoxHeight != self.inputBoxCtrl.mj_h) {
            self.inputBoxCtrl.frame = CGRectMake(0, self.listView.maxY, IMSCREEN_WIDTH, inputBoxHeight);
        }
        
    }];
}

/**
 对比两条消息，是否显示时间
 
 @param messageModel 最新的消息
 @return YES：显示 NO:不显示
 */
- (BOOL)isShowTimeWithNewMessageModel:(IMMessageModel *)messageModel
                      previousMessage:(IMMessageModel *)previousMessage
{
    NSTimeInterval prevTime = 0;
    NSTimeInterval lastTime = 0;
    
    if (messageModel.direction == IMMessageSenderTypeSender)
    {
        lastTime = [messageModel.sendTime integerValue];
    }
    else
    {
        lastTime = [messageModel.recvTime integerValue];
    }
    
    if (!previousMessage) {
        return YES;
    }
    if (previousMessage.direction == IMMessageSenderTypeSender)
    {
        prevTime = [previousMessage.sendTime integerValue];
    }
    else
    {
        prevTime = [previousMessage.recvTime integerValue];
    }
    return [NSDate showTimeWithPreviousTime:prevTime lastTime:lastTime];
}

/**
 根据会话和消息返回json字符串
 
 @param model 会话模型
 @param messageModel 消息模型
 @param transformComplete json转换完成回调
 */
- (void)jsonStrWithConversationModel:(IMConversationModel *)model
                        messageModel:(IMMessageModel *)messageModel
                           indexPath:(NSIndexPath *)indexPath
                   transformComplete:(void(^)(NSString *jsonStr))transformComplete
{
    if (indexPathRow == indexPath.row) {
        return;
    }
    
    dispatch_async(defaultQueue, ^{
        
        self->indexPathRow = indexPath.row;
        [self updateMessageSendStatus:IMMessageSendStatusSending
                            indexPath:indexPath
                       localMessageId:messageModel.messageId
                         serversMsgId:@""];
        
        __block NSString *jsonStr;
        NSString *fromUserName = [[IMAppDefaultUtil sharedInstance] getUserName];
        
        NSMutableDictionary *messageDic       = [NSMutableDictionary dictionary];
        messageDic[msg_id_key]                 = @0;
        messageDic[to_user_name_key]           = model.conversationName;
        messageDic[to_user_id_key]             = model.chatToJid.user;
        messageDic[from_user_name_key]        = fromUserName;
        messageDic[from_employee_id_key]      = @"-1";
        messageDic[msg_type_key]              = @(messageModel.msgType);
        if (![messageModel.content isKindOfClass:[NSData class]]) {
            messageDic[msg_content_key]           = messageModel.content;
        }
        if (messageModel.fileUrl && messageModel.fileUrl.length == 0) {
            messageDic[msg_content_key]           = messageModel.fileUrl;
        }
        
        messageDic[send_time_key]             = [NSString stringWithFormat:@"%ld",(long)messageModel.sendTime];
        messageDic[recv_time_key]              = @"";
        messageDic[voice_time_key]             = [NSString stringWithFormat:@"%d", messageModel.duringTime];
        messageDic[picture_type_key]           = @0;
        
        NSMutableDictionary *conversationDic  = [NSMutableDictionary dictionary];
        conversationDic[conversation_name_key] = model.conversationName;
        conversationDic[conversation_id_key]   = model.conversationId;
        conversationDic[chat_type_key]         = @0;
        conversationDic[head_img_key]          = @"";
        conversationDic[msg_key]               = messageDic;
        
        if (messageModel.msgType == IMMessageTypeImage || messageModel.msgType == IMMessageTypeVoice) {
            NSData *fileData;
            if (messageModel.fileData) {
                fileData = messageModel.fileData;
            }
            else {
                fileData = [[NSData alloc] initWithContentsOfFile:[NSFileManager pathUserSettingImage:messageModel.content]];
            }
            
            //            NSString *type = messageModel.msgType == IMMessageTypeImage ? @"png" : @"aac";
            //            [IMInteractionWrapper uploadFileToFileServerWithData:fileData fileName:type block:^(NSString *url, int errorCode, NSString *errorMsg) {
            //
            //                if (!errorCode)
            //                {
            //                    messageDic[MSG_CONTENT_KEY]       = url;
            //                    conversationDic[kMSG_KEY]       = messageDic;
            //                    jsonStr = [conversationDic dictionaryTurnJson];
            //
            //                    if (transformComplete) {
            //                        transformComplete(jsonStr);
            //                    }
            //                }
            //            }];
        }
        else {
            
            jsonStr = [conversationDic dictionaryTurnJson];
            if (transformComplete) {
                transformComplete(jsonStr);
            }
        }
    });
}

#pragma mark -图片视频浏览器
- (void)photoBrowserWithChatTableViewCell:(id)chatTableViewCell messageModel:(IMMessageModel *)messageModel {
    
    [visiblePhotoPreviews removeAllObjects];
    
    NSIndexPath *clickIndex = [chatTableViewCell indexPath];
    // 获取当前显示在界面上的图片或视频
    NSArray *indexPaths = [self.listView indexPathsForVisibleRows];
    
    for (NSIndexPath *indexPath in indexPaths)
    {
        id cell = [self.listView cellForRowAtIndexPath:indexPath];
        if ([cell isKindOfClass:[IMChatImageTableViewCell class]])
        {
            IMChatImageTableViewCell *imageCell = cell;
            IMMessageModel *msgModel = imageCell.messageModel;
            IMPhotoPreviewModel *model = [IMPhotoPreviewModel new];
            model.content      = msgModel.fileData;
            model.tapImageView = imageCell.messageImageView;
            model.messageId    = msgModel.messageId;
            
            [visiblePhotoPreviews addObject:model];
        }
        else if ([cell isKindOfClass:[IMChatVideoTableViewCell class]])
        {
            IMChatVideoTableViewCell *videoCell = cell;
            IMMessageModel *msgModel   = videoCell.messageModel;
            IMPhotoPreviewModel *model = [IMPhotoPreviewModel new];
            model.content             = videoCell.messageModel.fileData;
            if (videoCell.messageModel.content) {
                model.content         = videoCell.messageModel.content;
            }
            model.tapImageView        = videoCell.videoImageView;
            model.messageId           = msgModel.messageId;
            model.videoUrl = videoCell.messageModel.content;
            
            [visiblePhotoPreviews addObject:model];
        }
    }
    
    if ([chatTableViewCell isKindOfClass:[IMChatImageTableViewCell class]])
    {
        IMChatImageTableViewCell *imageCell = (IMChatImageTableViewCell *)chatTableViewCell;
        IMMessageModel *msgModel     = self.dataSource[clickIndex.row];
        crrentTapPhoto              = [IMPhotoPreviewModel new];
        crrentTapPhoto.messageId    = msgModel.messageId;
        crrentTapPhoto.tapImageView = imageCell.messageImageView;
        crrentTapPhoto.content      = msgModel.fileData;
    }
    else if ([chatTableViewCell isKindOfClass:[IMChatVideoTableViewCell class]])
    {
        IMChatVideoTableViewCell *imageCell = (IMChatVideoTableViewCell *)chatTableViewCell;
        IMMessageModel *msgModel     = self.dataSource[clickIndex.row];
        crrentTapPhoto              = [IMPhotoPreviewModel new];
        crrentTapPhoto.messageId    = msgModel.messageId;
        crrentTapPhoto.tapImageView = imageCell.videoImageView;
        crrentTapPhoto.content      = messageModel.fileData;
        if (messageModel.content) {
            crrentTapPhoto.content  = messageModel.content;
        }
        crrentTapPhoto.videoUrl     = messageModel.content;
    }
    
    self.imageDatas = [NSArray arrayWithArray:self.allImageDatas];
    __block NSInteger index = 0;
    [self.imageDatas enumerateObjectsUsingBlock:^(IMPhotoPreviewModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.messageId isEqualToString:self->crrentTapPhoto.messageId]) {
            index = idx;
        }
    }];
    
    IMPhotoBrowser *photoBrowser   = [IMPhotoBrowser showPhotoBrowserWithCurrentImageIndex:index imageCount:self.imageDatas.count datasource:self];
    photoBrowser.sourceImageView  = crrentTapPhoto.tapImageView;
    photoBrowser.pageControlStyle = IMPhotoBrowserPageControlStyleNone;
    photoBrowser.isAutoPlay       = messageModel.msgType == IMMessageTypeVideo;
    
    [photoBrowser setActionSheetWithTitle:@"" delegate:self cancelButtonTitle:nil deleteButtonTitle:nil otherButtonTitles:@"保存图片", nil];
}

#pragma mark - IMInputBoxViewCtrl代理
- (void)inputBoxCtrl:(IMInputBoxViewCtrl *)inputBoxCtrl didChangeInputBoxHeight:(CGFloat)height {
    CGRect inputRect = [[self class] inputBoxViewCtrlWrthFrame];
    CGFloat inputHeight = inputRect.size.height;
    //  不能小于输入框规定的高度
    if (height >= inputHeight) {
        inputHeight = height;
    }
    self.listView.frame  = CGRectMake(0, 0, IMSCREEN_WIDTH, IMSCREEN_HEIGHT - IMSTATUSBAR_NAVBAR_HEIGHT - inputHeight);
    [self scrollTableViewBottom];
    self.inputBoxCtrl.frame = CGRectMake(0, self.listView.maxY, IMSCREEN_WIDTH, inputHeight);
}

#pragma mark - 发送消息
- (void)inputBoxCtrl:(IMInputBoxViewCtrl *)inputBoxCtrl sendTextMessage:(NSString *)textMessage {
    
    if ([textMessage isEmptyString])
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"不能发送空白消息" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
    // 不考虑是否显示时间时的行高
    __block CGFloat cellHeight      = -1;
    __block IMMessageModel *model    = [[IMMessageModel alloc] init];
    
    NSString *currentTimeInterval = [NSDate getCurrentTimestamp];
    
    model.msgType           = IMMessageTypeText;
    model.messageChatType   = IMMessageChatTypeSingle;
    model.direction         = IMMessageSenderTypeSender;
    model.messageReadStatus = IMMessageReadStatusRead;
    model.content           = textMessage;
    model.sendTime          = currentTimeInterval;
    model.recvTime          = currentTimeInterval;
    model.toUserName        = _conversation.conversationName;
    model.messageSendStatus = IMMessageSendStatusSendSuccess;
    model.lastMessage       = [self lastMessage];
    model.messageId         = currentTimeInterval;
    
    BOOL isShowTime         = [self isShowTimeWithNewMessageModel:model previousMessage:[self lastMessage]];
    model.showMessageTime   = isShowTime;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataSource.count inSection:0];
    
    kWeakSelf;
    dispatch_async(defaultQueue, ^{
        
        [model messageProcessingWithFinishedCalculate:^(CGFloat rowHeight, CGSize messageSize, BOOL complete) {
            
            cellHeight = rowHeight;
            
            [self->sendMessage lock];
            [weakSelf addMessage:model];
            [self->sendMessage unlock];
            
        }];
        //     向服务端发消息
        [KIMXMPPHelper sendMessageModel:model to:self.conversation.chatToJid];
    });
}

- (void)inputBoxCtrl:(IMInputBoxViewCtrl *)inputBoxCtrl didSelectedMoreView:(IMInputBoxMoreStatus)inputBoxMoreStatus
{
    if (inputBoxMoreStatus == IMInputBoxMoreStatusPhoto)
    {
        [self selectPhoto];
    }
    else if (inputBoxMoreStatus == IMInputBoxMoreStatusTakePhoto)
    {
        // v2.0.0暂不支持拍摄功能
        [self takePhoto];
    }
    else if (inputBoxMoreStatus == IMInputBoxMoreStatusMail)
    {
        IMMailAccountInfoModel *mailAccountInfoModel = [[IMAppDefaultUtil sharedInstance] getMailInfo];
        if (mailAccountInfoModel.emailAccount == nil)
        {
            [SVProgressHUD showImage:[UIImage imageNamed:@""] status:@"请先设置邮箱账号"];
            return;
        }
        
        //        IMWriteMailViewController *writeMail  = [[IMWriteMailViewController alloc] init];
        //        writeMail.contantsAddressArray       = _toAddressArray;
        //        writeMail.intoType                   = IMMailEditTypeContants;
        //        UINavigationController *writeMailNav = [[UINavigationController alloc] initWithRootViewController:writeMail];
        //        [self presentViewController:writeMailNav animated:YES completion:nil];
        
    }
    else if (inputBoxMoreStatus == IMInputBoxMoreStatusCallPhone)
    {
        // 拨打电话
        if (_phoneNumber && _phoneNumber.length) {
            NSString *str = [NSString stringWithFormat:@"tel:%@", _phoneNumber];;
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
    }
    
    [self updateViewFrame];
}

- (IMPhoto *)photoBrowser:(IMPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
    IMPhotoPreviewModel *currentModel = self.imageDatas[index];
    IMPhoto *photo = [IMPhoto new];
    __block UIImage *image;
    if ([currentModel.content isKindOfClass:[NSData class]]) {
        image = [UIImage imageWithData:currentModel.content];
    }
    else {
        NSString *path = currentModel.content;
        if ([path containsString:@"http://"] || [path containsString:@"https://"]){
            UIImageView *imageView = [UIImageView new];
            [imageView sd_setImageWithURL:[NSURL URLWithString:currentModel.content] completed:^(UIImage *images, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                image = images;
            }];
        }
        else if ([path containsString:@"storage/msgs/"]) {
            NSString *imagePath = [NSFileManager pathUserSettingImage:path];
            image = [UIImage imageWithContentsOfFile:imagePath];
        }
        photo.imageUrl = path;
    }
    photo.defaultImage = image;
    photo.thumbUrl = currentModel.thumbUrl;
    photo.videoUrl = currentModel.videoUrl;
    if (currentModel.imageUrl) {
        photo.imageUrl = currentModel.imageUrl;
    }
    
    return photo;
}

- (UIView *)photoBrowser:(IMPhotoBrowser *)browser sourceImageViewForIndex:(NSInteger)index{
    IMPhotoPreviewModel *currentModel = self.imageDatas[index];
    if (visiblePhotoPreviews.count > 1){
        UIImageView *imageView = nil;
        for (IMPhotoPreviewModel *model in visiblePhotoPreviews){
            if (model.messageId == currentModel.messageId){
                imageView = model.tapImageView;
            }
        }
        if (imageView){
            return imageView;
        }
    }
    return crrentTapPhoto.tapImageView;
}

- (void)photoBrowser:(IMPhotoBrowser *)browser clickActionSheetIndex:(NSInteger)actionSheetindex currentImageIndex:(NSInteger)currentImageIndex
{
    // do something yourself
    switch (actionSheetindex)
    {
        case 0: // 保存
        {
            [browser saveCurrentShowImage];
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    NSLog(@"-----------------------收到内存警告-------------------");
    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
    // 1.取消正在下载的操作
    [mgr cancelAll];
    // 2.清除内存缓存
    [mgr.imageCache clearMemory];
}

- (void)dealloc {
    [IMNotificationCenter removeObserver:self];
    [self.inputBoxCtrl.inputBox removeObserver:self forKeyPath:@"recordState" context:nil];
    [self.recordView removeFromSuperview];
    self.recordView = nil;
}

@end
