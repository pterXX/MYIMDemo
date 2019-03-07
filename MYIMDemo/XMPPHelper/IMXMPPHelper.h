//
//  IMXMPPHelper.h
//  MYIMDemo
//
//  Created by admin on 2019/3/6.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XMPP.h>
#import <XMPPFramework/XMPPFramework.h>

NS_ASSUME_NONNULL_BEGIN


#ifdef DEBUG

#define IM_XMMP_HOST_NAME @"xmpp.maiyuantek.com"
#define IM_XMPP_HOST_PORT (5222)
#define IM_XMPP_DOMAIN @"xmpp.maiyuantek.com"

#else

#define IM_XMMP_HOST_NAME @"192.168.2.2"
#define IM_XMPP_HOST_PORT (5222)
#define IM_XMPP_DOMAIN @"xushijie"

#endif

@class IMUserHelper;
typedef void(^IMXMPPSuccessBlock)(void);
typedef void(^IMXMPPFailBlock)(NSError *error);

typedef NS_ENUM(NSUInteger, IMXMPPErrorCode) {
    IMXMPPErrorCodeConnect = 1001,
    IMXMPPErrorCodeLogin
};

@interface IMXMPPHelper : NSObject
@property (nonatomic ,strong) IMUserHelper                        *userHelper;
@property (nonatomic ,strong) NSString                            *username;
@property (nonatomic ,strong) NSString                            *password;
//表示是否手动验证TLS/SSL
@property (nonatomic ,assign) BOOL                                customCertEvaluation;
//表示一个地址
@property (nonatomic ,strong) XMPPJID                             *myJID;
//用于连接服务器
@property (nonatomic ,strong) XMPPStream                          *xmppStream;
//断线重连模块
@property (nonatomic ,strong) XMPPReconnect                       *xmppReconnect;
//接入流管理模块，用于流恢复跟消息确认，在移动端很重要
@property (nonatomic ,strong) XMPPStreamManagementMemoryStorage   *storage;
@property (nonatomic ,strong) XMPPStreamManagement                *xmppStreamManagement;
//接入好友模块，可以获取好友列表
@property (nonatomic ,strong) XMPPRosterMemoryStorage             *xmppRosterMemoryStorage;
@property (nonatomic ,strong) XMPPRoster                          *xmppRoster;
//接入消息模块，将消息存储到本地
@property (nonatomic ,strong) XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingCoreDataStorage;
@property (nonatomic ,strong) XMPPMessageArchiving                *xmppMessageArchiving;
//  文件接收
@property (nonatomic, strong) XMPPIncomingFileTransfer            *xmppIncomingFileTransfer;


+ (IMXMPPHelper *)sharedHelper;


/**
 登录

 @param userName 用户名
 @param password 密码
 @param success c登录成功后的回调
 @param fail 失败后的回调
 */
-(void)loginWithName:(NSString *)userName
         andPassword:(NSString *)password
             success:(IMXMPPSuccessBlock)success
                fail:(IMXMPPFailBlock)fail;
/**
 *  退出登录
 */
- (void)logOut;

/**
 *  上线
 */
- (void)goOnline;

/**
 *  下线
 */
- (void)goOffline;

/**
 *  发送消息
 *
 *  @param message 消息内容
 *  @param jid     发送对方的ID
 */
- (void)sendMessage:(NSString *)message to:(XMPPJID *)jid;

@end

NS_ASSUME_NONNULL_END
