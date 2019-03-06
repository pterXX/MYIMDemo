//
//  IMXMPPHelper.m
//  MYIMDemo
//
//  Created by admin on 2019/3/6.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "IMXMPPHelper.h"


@interface IMXMPPHelper()<XMPPStreamDelegate>

@property (nonatomic ,copy) IMXMPPFailBlock    fail;//  失败
@property (nonatomic ,copy) IMXMPPSuccessBlock success;//  成功

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
        [IMNotificationCenter addObserver:self selector:@selector(applicationWillTerminate) name:UIApplicationWillTerminateNotification object:nil];
    }
    return self;
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
        _xmppRosterMemoryStorage = [[XMPPRosterMemoryStorage alloc] init];
        _xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:_xmppRosterMemoryStorage];
        [_xmppRoster activate:self.xmppStream];
        [_xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        //接入消息模块，将消息存储到本地
        _xmppMessageArchivingCoreDataStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
        _xmppMessageArchiving = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:_xmppMessageArchivingCoreDataStorage dispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 9)];
        [_xmppMessageArchiving activate:self.xmppStream];
    }
}

#pragma mark -- go onlie, offline
//  登录
-(void)loginWithName:(NSString *)userName andPassword:(NSString *)password success:(IMXMPPSuccessBlock)success fail:(IMXMPPFailBlock)fail{
    _myJID = [XMPPJID jidWithUser:userName domain:IM_XMPP_DOMAIN resource:nil];
    self.password = password;
    self.userHelper      = [IMUserHelper sharedHelper];
    IMUser *user         = [[IMUser alloc] init];
    user.nikeName        = userName;
    user.username        = userName;
    user.remarkName      = userName;
    self.userHelper.user = user;
    self.success         = success;
    self.fail            = fail;
    [self.xmppStream setMyJID:_myJID];
    
    NSError *error = nil;
    // 如果以前连接过服务，要断开
    [_xmppStream disconnect];
    [_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error];
    if (error) {
        NSLog(@"%@",error);
        [self failCompleteCode:IMXMPPErrorCodeConnect description:@"连接失败,请检查服务器地址"];
    }
}

-(void)logOut{
    [self goOffline];
    [_xmppStream disconnectAfterSending];
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
- (void)sendMessage:(NSString *)message to:(XMPPJID *)jid{
    XMPPMessage* newMessage = [[XMPPMessage alloc] initWithType:@"chat" to:jid];
    [newMessage addBody:message]; //消息内容
    [_xmppStream sendElement:newMessage];
}

#pragma mark - XMPPStreamDelegate
//将要连接
- (void)xmppStreamWillConnect:(XMPPStream *)sender{
    NSLog(@"%s",__func__);
}

//已经连接
- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    NSError *error = nil;
    if (![[self xmppStream] authenticateWithPassword:self.password error:&error]){
        NSLog(@"Error authenticating: %@", error);
    }
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    if (error) {
        [self failCompleteCode:IMXMPPErrorCodeConnect description:@"连接失败,请检查服务器地址"];
    }
}

//已经登录
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    NSLog(@"%s",__func__);
    [self goOnline];
    //启用流管理
    [_xmppStreamManagement enableStreamManagementWithResumption:YES maxTimeout:0];
    
    //  登录成功后的回调
    if (self.success) {
        self.success();
        self.fail = nil;
    }
}

//登陆失败
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error{
    NSLog(@"%s",__func__);
    [self failCompleteCode:IMXMPPErrorCodeLogin description:@"登录失败,请检查登录账户和密码"];
}


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
    }
}

#pragma mark -- XMPPMessage Delegate
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    NSLog(@"%s",__func__);
}

- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message{
    NSLog(@"%s--%@",__FUNCTION__, message);
}

- (void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error{
    NSLog(@"%s--%@",__FUNCTION__, message);
}

#pragma mark -- Roster

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence{
    //对方上线或离线,更新状态
    //xmppRosterDidChange
}

- (void)xmppRosterDidChange:(XMPPRoster *)sender{
    [IMNotificationCenter postNotificationName:@"RosterChanged" object:nil];
}

#pragma mark ===== 文件接收=======

//是否同意对方发文件
- (void)xmppIncomingFileTransfer:(XMPPIncomingFileTransfer *)sender didReceiveSIOffer:(XMPPIQ *)offer{
    NSLog(@"%s",__FUNCTION__);
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

#pragma mark -- terminate
/**
 *  申请后台时间来清理下线的任务
 */
-(void)applicationWillTerminate
{
    UIApplication *app=[UIApplication sharedApplication];
    UIBackgroundTaskIdentifier taskId = 0;
    
    taskId = [app beginBackgroundTaskWithExpirationHandler:^(void){
        [app endBackgroundTask:taskId];
    }];
    
    if(taskId==UIBackgroundTaskInvalid){
        return;
    }
    
    //只能在主线层执行
    [_xmppStream disconnectAfterSending];
}

@end
