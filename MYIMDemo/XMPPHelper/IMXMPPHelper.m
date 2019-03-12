//
//  IMXMPPHelper.m
//  MYIMDemo
//
//  Created by admin on 2019/3/6.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "IMXMPPHelper.h"

static NSString * const kAvailable     = @"available";//  上线
static NSString * const kAway          = @"away";//  离开
static NSString * const kDotNotDisturb = @"do not disturb";//  忙碌
static NSString * const kSubscribe     = @"subscribe";//  订阅
static NSString * const kUnavailable   = @"unavailable";//  下线
static NSString * const kUnsubscribe   = @"unsubscribe";//  取消订阅

@interface IMXMPPHelper()<XMPPStreamDelegate,XMPPRosterMemoryStorageDelegate,XMPPRosterStorage>

@property (nonatomic ,assign) BOOL               xmppNeedRegister;// 是否是注册
@property (nonatomic ,copy  ) IMXMPPFailBlock    fail;//  失败
@property (nonatomic ,copy  ) IMXMPPSuccessBlock success;//  成功
@property (nonatomic ,copy  ) XMPPPresence       *presence;// 代表用户在线状态

@end

@implementation IMXMPPHelper
static IMXMPPHelper *helper;

+ (IMXMPPHelper *)sharedHelper
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        helper = [[IMXMPPHelper alloc] init];
        [helper setupStream];
    });
    return helper;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addApplicationNotification];
    }
    return self;
}

- (IMUserHelper *)userHelper{
    if (!_userHelper) {
        _userHelper = [IMUserHelper sharedHelper];
    }
    return _userHelper;
}

- (void)setupStream{
    if (!_xmppStream) {
        _xmppStream = [[XMPPStream alloc] init];
        [_xmppStream setHostName:IM_XMMP_HOST_NAME];  //设置xmpp服务器地址
        [_xmppStream setHostPort:IM_XMPP_HOST_PORT];  //设置xmpp服务器端口号
        [_xmppStream setKeepAliveInterval:30];        //心跳包间隔时长
        
        //  保证xmpp早后台运行。iOS10 需要使用iOS 10不再提供后台套接字。您必须使用Pushkit和XEP-0357模块。
        _xmppStream.enableBackgroundingOnSocket = YES;
        [_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        _xmppReconnect = [[XMPPReconnect alloc] init];
        [_xmppReconnect setAutoReconnect:YES];  //   是否自动重连
        [_xmppReconnect activate:_xmppStream];
        
        //接入流管理模块，用于流恢复跟消息确认，在移动端很重要
        _storage = [XMPPStreamManagementMemoryStorage new];
        _xmppStreamManagement = [[XMPPStreamManagement alloc] initWithStorage:_storage];
        _xmppStreamManagement.autoResume = YES;
        [_xmppStreamManagement addDelegate:self delegateQueue:dispatch_get_main_queue()];
        [_xmppStreamManagement activate:self.xmppStream];
        
        //接入好友模块，可以获取好友列表
        _xmppRosterMemoryStorage  = [[XMPPRosterMemoryStorage  alloc] init];
        _xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:_xmppRosterMemoryStorage ];
        [_xmppRoster activate:self.xmppStream];
        [_xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
        //设置好友同步策略,XMPP一旦连接成功，同步好友到本地
        [_xmppRoster setAutoFetchRoster:YES]; //自动同步，从服务器取出好友
        //关掉自动接收好友请求，默认开启自动同意
        [_xmppRoster setAutoAcceptKnownPresenceSubscriptionRequests:NO];

        //接入消息模块，将消息存储到本地
        _xmppMessageArchivingCoreDataStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
        _xmppMessageArchiving = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:_xmppMessageArchivingCoreDataStorage dispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 9)];
        [_xmppMessageArchiving activate:self.xmppStream];
        
        //添加vCard模块
        _vCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
        _vCardModule = [[XMPPvCardTempModule alloc] initWithvCardStorage: self.vCardStorage];
        [self.vCardModule activate:_xmppStream];
        _vCardAvatorModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:self.vCardModule];
        [self.vCardAvatorModule activate:_xmppStream];
    }
}

#pragma mark -- go onlie, offline
- (void)initUser:(IMXMPPFailBlock _Nonnull)fail password:(NSString * _Nonnull)password success:(IMXMPPSuccessBlock _Nonnull)success userName:(NSString * _Nonnull)userName {
    _myJID = [XMPPJID jidWithUser:userName domain:IM_XMPP_DOMAIN resource:nil];
    self.userHelper.userAccount = userName;
    self.userHelper.password = password;
    self.success         = success;
    self.fail            = fail;
    [self.xmppStream setMyJID:_myJID];
    
    NSError *error = nil;
    // 如果以前连接过服务，要断开
    [_xmppStream disconnect];
    [_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error];
    if (error) {
        DDLogInfo(@"%@",error);
        [self failCompleteCode:IMXMPPErrorCodeConnect description:@"连接失败,请检查服务器地址"];
    }
}

//  登录
-(void)loginWithName:(NSString *)userName andPassword:(NSString *)password success:(IMXMPPSuccessBlock)success fail:(IMXMPPFailBlock)fail{
    self.xmppNeedRegister = NO;
    [self initUser:fail password:password success:success userName:userName];
}

//  注册
-(void)registerWithName:(NSString *)userName andPassword:(NSString *)password success:(IMXMPPSuccessBlock)success fail:(IMXMPPFailBlock)fail{
    self.xmppNeedRegister = YES;
    [self initUser:fail password:password success:success userName:userName];
}

//  用户授权
-(void)userAuth{
    NSError *error = nil;
    if (self.xmppNeedRegister) {
        //  用户注册，发送注册请求
        [[self xmppStream] registerWithPassword:self.userHelper.password error:&error];
    }else{
        //  用户登录，发送身份验证请求
        [[self xmppStream] authenticateWithPassword:self.userHelper.password error:&error];
    }
    if (error) DDLogInfo(@"%@",error);
}

-(void)logOut{
    [self goOffline];
    [_xmppStream disconnectAfterSending];
    [self.userHelper signOut];
}

- (void)goOnline{
    XMPPPresence *presence = [XMPPPresence presence]; // type="available" is implicit
    [[self xmppStream] sendElement:presence];
}

- (void)goOffline{
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [[self xmppStream] sendElement:presence];
}

// 发送消息
- (void)sendMessageModel:(IMMessageModel *)message to:(XMPPJID *)jid{
    XMPPMessage* newMessage = [[XMPPMessage alloc] initWithType:@"chat" to:jid];
    if (message.messageId.isEmptyString) {
        message.messageId = [NSDate getCurrentTimestamp];
    }
    if (message.fileData && self.fileUploadIsBase64) {
       message.content = [message.fileData base64EncodedStringWithOptions:0];
    }
    [newMessage addOriginId:message.messageId];
    [newMessage addBody:message.messageBody]; //消息内容
    XMPPElement *dataBody = [XMPPElement elementWithName:kMessageElementDataBodyName stringValue:[message modelConverJson]];
    [newMessage addChild:dataBody];
    [_xmppStream sendElement:newMessage];
}

/*
//  发送图片
- (void)sendImage:(UIImage *)img to:(XMPPJID *)jid{
    [img compressedWithImageKilobyte:1024 imageBlock:^(NSData *imageData) {
         [self sendMessageWithData:imageData bodyName:@"[图片]" chatType:@"img" to:jid];
    }];
}

//  发送语音
- (void)sendVoice:(UIImage *)img to:(XMPPJID *)jid{
    [img compressedWithImageKilobyte:1024 imageBlock:^(NSData *imageData) {
        [self sendMessageWithData:imageData bodyName:@"[语音]" chatType:@"voice" to:jid];
    }];
}


// 发送二进制文件
- (void)sendMessageWithData:(NSData *)data bodyName:(NSString *)name chatType:(NSString *)chatType to:(XMPPJID *)jid {
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:jid];
    [message addBody:name];
    // 转换成base64的编码
    NSString *base64str = [data base64EncodedStringWithOptions:0];
    // 设置节点内容
    XMPPElement *attachment = [XMPPElement elementWithName:@"attachment" stringValue:base64str];
    XMPPElement *type = [XMPPElement elementWithName:@"chatType" stringValue:chatType]; //  这里的chatType是自定义类型，img是暂定内容，后期可以添加其他类型
    // 包含子节点
    [message addChild:attachment];
    [message addChild:type];
    // 发送消息
    [_xmppStream sendElement:message];
}
*/

//  添加请求
- (void)addFriend:(IMUser *)user{
    if (!user) return;
    XMPPJID *jid = [XMPPJID jidWithUser:user.userID domain:IM_XMPP_DOMAIN resource:nil];
    //这里的nickname是我对它的备注，并非他得个人资料中得nickname
    [KIMXMPPHelper.xmppRoster addUser:jid withNickname:user.remarkName];
}

//  同意订阅请求用户，执行被添加好友的操作
-(void)acceptPresenceSubscriptionRequest{
    if (self.presence == nil) return;
    [self.xmppRoster acceptPresenceSubscriptionRequestFrom:self.presence.from andAddToRoster:YES];
    self.presence = nil;
}

//  拒接订阅请求，用户拒绝被添加好友的操作
-(void)rejectPresenceSubscriptionRequest{
    if (self.presence == nil) return;
    [self.xmppRoster rejectPresenceSubscriptionRequestFrom:self.presence.from];
    self.presence = nil;
}

#pragma mark - XMPPStreamDelegate
#pragma mark ------ 连接
//将要连接
- (void)xmppStreamWillConnect:(XMPPStream *)sender{
    DDLogInfo(@"将要连接服务器");
}

//已经连接
- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    DDLogInfo(@"已经连接服务器");
    //  用户授权
    [self userAuth];
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    if (error) {
        [self failCompleteCode:IMXMPPErrorCodeConnect description:@"连接失败,请检查服务器地址"];
    }
}

#pragma mark ------ 授权
//已经授权
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    DDLogInfo(@"登录成功");
    [self goOnline];
    //  登录成功后的回调
    [self successComplete];
    //启用流管理
    [_xmppStreamManagement enableStreamManagementWithResumption:YES maxTimeout:0];
    
}

// 授权失败
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error{
    DDLogError(@"登录授权失败 %@",error);
    [self failCompleteCode:IMXMPPErrorCodeLogin description:@"登录失败,请检查登录账户和密码"];
}

#pragma mark ------ 注册
-(void)xmppStreamDidRegister:(XMPPStream *)sender{
    self.xmppNeedRegister =NO;
    [self goOnline];
    //  登录成功后的回调
    [self successComplete];
}

- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error{
    DDLogError(@"注册授权失败 %@",error);
    NSString *str = [self analysisForDDXMLElement:error elementsName:@"error" nodeName:@"code"];
    if (str && [str isEqualToString:@"409"]) {
        [self failCompleteCode:IMXMPPErrorCodeDidRegister description:@"注册失败,请检查登录账户和密码"];
    }else{
        [self failCompleteCode:IMXMPPErrorCodeRegister description:@"注册失败,请检查登录账户和密码"];
    }
}

#pragma mark ------ SSL/TLS
/**
 此方法在流通过SSL/TLS得到保护之后调用。
 如果服务器在打开过程中需要安全连接，则可以调用此方法，
 或者如果secureConnection:方法是手动调用的。
 */
- (void)xmppStreamDidSecure:(XMPPStream *)sender{
    [sender.asyncSocket readDataWithTimeout:-1 tag:1];
}

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary<NSString *,NSObject *> *)settings{
    [settings setObject:sender.myJID.domain forKey:(NSString *)kCFStreamSSLPeerName];
    //  如果手动信任证书
    if (self.customCertEvaluation) [settings setObject:@(YES) forKey:GCDAsyncSocketManuallyEvaluateTrust];
}

//  手动信任
- (void)xmppStream:(XMPPStream *)sender didReceiveTrust:(SecTrustRef)trust completionHandler:(void (^)(BOOL))completionHandler{
    completionHandler(self.customCertEvaluation);
}

#pragma mark -- XMPPMessage Delegate
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    DDLogInfo(@"接收消息--%@",message);
    if (self.messageReceiveBlock) {
        self.messageReceiveBlock(message);
    }
}

- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message{
    DDLogInfo(@"发送消息成功--%@", message);
    if (self.messageSendBlock) {
        self.messageSendBlock(message);
    }
}

- (void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error{
    DDLogError(@"发送消息失败--%@", message);
    if (self.messageSendFailBlock) {
        self.messageSendFailBlock(message);
    }
}

#pragma mark -- Roster
//  好友改变
- (void)xmppRosterDidChange:(XMPPRosterMemoryStorage *)sender{
    DDLogInfo(@"好友列表改变");
//    [IMNotificationCenter postNotificationName:kXmppRosterChangeNot object:nil];
}

//  收到好友列表IQ会进入的方法，并且已经存入我的存储器
- (void)xmppRosterDidEndPopulating:(XMPPRoster *)sender{
    DDLogInfo(@"好友列表改变");
    [IMNotificationCenter postNotificationName:kXmppRosterChangeNot object:nil];
}

/** 收到出席订阅请求（代表对方想添加自己为好友) */
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    DDLogInfo(@"订阅请求 %@",presence);
    //添加好友一定会订阅对方，但是接受订阅不一定要添加对方为好友
    [IMNotificationCenter postNotificationName:kXmppSubscriptionRequestNot object:presence];
    
    //同意并添加对方为好友
    //    [self.xmppRoster acceptPresenceSubscriptionRequestFrom:presence.from andAddToRoster:YES];
    //拒绝的方法
    //    [self.xmppRoster rejectPresenceSubscriptionRequestFrom:presence.from];
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
    DDLogInfo(@"%@",presence);
    //收到对方取消定阅我得消息
    if ([presence.type isEqualToString:kUnsubscribe]) {
        //从我的本地通讯录中将他移除
        [self.xmppRoster removeUser:presence.from];
    }
}

#pragma mark =====头像修改 =======
/**
 只要对方的头像发生更改, 或者自己上传了新都头像, 就会调用上述的两个代理方法, 那么, 我们在这两个代理方法中
 */
/**接收到头像更改*/
- (void)xmppvCardAvatarModule:(XMPPvCardAvatarModule *)vCardTempModule didReceivePhoto:(UIImage *)photo forJID:(XMPPJID *)jid {
    if (self.changeAvatarPhoto) {
        self.changeAvatarPhoto();
    }
}

/** 上传头像成功*/
- (void)xmppvCardTempModuleDidUpdateMyvCard:(XMPPvCardTempModule *)vCardTempModule {
    if (self.changeAvatarPhoto) {
        self.changeAvatarPhoto();
    }
}

#pragma mark ===== 文件接收=======

//是否同意对方发文件
- (void)xmppIncomingFileTransfer:(XMPPIncomingFileTransfer *)sender didReceiveSIOffer:(XMPPIQ *)offer{
    DDLogInfo(@"%s",__FUNCTION__);
    [self.xmppIncomingFileTransfer acceptSIOffer:offer];
}

//存储文件 音频为amr格式  图片为jpg格式
- (void)xmppIncomingFileTransfer:(XMPPIncomingFileTransfer *)sender didSucceedWithData:(NSData *)data named:(NSString *)name{
    XMPPJID *jid = [sender.xmppStream.myJID copy];
    NSString *subject;
    NSString *extension = [name pathExtension];
    if ([@"amr" isEqualToString:extension]) {
        subject = @"voice";
    }else if([@"jpg" isEqualToString:extension]){
        subject = @"picture";
    }
    
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:jid];
    [message addAttributeWithName:@"from" stringValue:sender.xmppStream.myJID.bare];
    [message addSubject:subject];
    
    NSString *path =  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:[XMPPStream generateUUID]];
    path = [path stringByAppendingPathExtension:extension];
    [data writeToFile:path atomically:YES];
    [message addBody:path.lastPathComponent];
    [self.xmppMessageArchivingCoreDataStorage archiveMessage:message outgoing:NO xmppStream:self.xmppStream];
}

#pragma mark -- Application life cycle
- (void)addApplicationNotification{
    //  程序将要推出操作
    [IMNotificationCenter addObserver:self
                             selector:@selector(applicationWillTerminate)
                                 name:UIApplicationWillTerminateNotification object:nil];
    
    //  程序获得焦点
    [IMNotificationCenter addObserver:self
                             selector:@selector(applicationDidBecomeActive)
                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    //  程序失去焦点
    [IMNotificationCenter addObserver:self
                             selector:@selector(applicationWillResignActiveNotification)
                                 name:UIApplicationWillResignActiveNotification object:nil];
}

/**
 *  申请后台时间来清理下线的任务
 */
-(void)applicationWillTerminate{
    UIApplication *app = [UIApplication sharedApplication];
    UIBackgroundTaskIdentifier taskId = 0;
    
    taskId = [app beginBackgroundTaskWithExpirationHandler:^(void){
        [app endBackgroundTask:taskId];
    }];
    
    if(taskId == UIBackgroundTaskInvalid){
        return;
    }
    
    //只能在主线层执行，断线
    [_xmppStream disconnectAfterSending];
}

/**
 *  获得焦点
 */
- (void)applicationDidBecomeActive{
    //  如果已经登录的话就直接返回
    if (self.userHelper.isLogin && self.userHelper.userAccount && self.userHelper.password) {
        //  重新登录
        [self loginWithName:self.userHelper.userAccount andPassword:self.userHelper.password success:nil fail:nil];
    }
    // 如果连接已经关闭
    if (self.xmppStream.isDisconnected ) {
       
    }
}


/**
 *  失去焦点
 */
- (void)applicationWillResignActiveNotification{
    [self goOffline];
}


/**
 初始化错误信息
 
 @param code 错误编码
 @param description 错误信息
 */
- (void)failCompleteCode:(NSInteger)code description:(NSString *)description{
    // 失败后的回调
    if (self.fail) {
        NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:code userInfo:@{NSLocalizedDescriptionKey:IMNoNilString(description)}];
        self.fail(error);
        self.success = nil;
        self.fail = nil;
    }
}


/**
 成功后的回调
 */
- (void)successComplete {
    IMUser *user         = [[IMUser alloc] init];
    // 测试的userID和nickname，remarkName 都是username，具体等线上修改
    user.userID          = self.userHelper.userAccount;
    user.nikeName        = self.userHelper.userAccount;
    user.username        = self.userHelper.userAccount;
    user.remarkName      = self.userHelper.userAccount;
    self.userHelper.user = user;
    if (self.success) {
        self.success();
        self.fail = nil;
        self.success = nil;
    }
}

- (NSString *)analysisForDDXMLElement:(id )doc elementsName:(NSString *)elementsForName nodeName:(NSString *)nodeName  {
    if (elementsForName == nil || doc == nil) return nil;
    if ([doc isKindOfClass:[DDXMLElement class]]) {
        DDXMLElement *element = (DDXMLElement *)doc;
        NSArray<DDXMLElement *> *elements = [element elementsForName:elementsForName];
        DDXMLNode *node = [element attributeForName:nodeName];
        if (node){
            return node.stringValue;
        }else{
            NSString *str = [self analysisForDDXMLElement:elements elementsName:elementsForName nodeName:nodeName];
            if (str) return str;
        }
    }else if([doc isKindOfClass:[NSArray class]]){
        NSArray *array = (NSArray *)doc;
        for (id sub in array) {
            NSString *str = [self analysisForDDXMLElement:sub elementsName:elementsForName nodeName:nodeName];
            if (str) return str;
        }
    }
    return nil;
}

@end
