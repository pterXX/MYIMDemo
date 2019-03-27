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
#import "IMUserHelper.h"


#ifdef DEBUG

#define IM_XMMP_HOST_NAME @"xmpp.maiyuantek.com"
#define IM_XMPP_HOST_PORT (5222)
#define IM_XMPP_DOMAIN @"xmpp.maiyuantek.com"

#else

#define IM_XMMP_HOST_NAME @"192.168.2.2"
#define IM_XMPP_HOST_PORT (5222)
#define IM_XMPP_DOMAIN @"xushijie"

#endif

NS_ASSUME_NONNULL_BEGIN

#define KIMXMPPHelper [IMXMPPHelper sharedHelper]

typedef void(^IMXMPPSuccessBlock)(void);
typedef void(^IMXMPPFailBlock)(NSError *error);
typedef void(^IMXMPPMessageBlock)(XMPPMessage *message);
typedef void(^IMXMPPFriendsListBlock)(id result);

typedef NS_ENUM(NSUInteger, IMXMPPErrorCode) {
    IMXMPPErrorCodeConnect = 1001, //  连接错误
    IMXMPPErrorCodeLogin,          //  登录错误
    IMXMPPErrorCodeRegister,       //  注册错误
    IMXMPPErrorCodeDidRegister,    //  已经注册，表示已存在用户
    IMXMPPErrorCodeDidUserExists   //  表示已存在好友
};

@interface IMXMPPHelper : NSObject
@property (nonatomic ,copy  ) IMUserHelper                        *userHelper;


@property (nonatomic ,copy) void(^imageUploadBlock)(NSData *imgData,void(^handleBlock)(NSString *fileUrl));

//表示是否手动验证IMS/SSL
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
@property (nonatomic ,strong) XMPPRosterMemoryStorage             *xmppRosterStorage;
@property (nonatomic ,strong) XMPPRoster                          *xmppRoster;
//接入消息模块，将消息存储到本地
@property (nonatomic ,strong) XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingCoreDataStorage;
@property (nonatomic ,strong) XMPPMessageArchiving                *xmppMessageArchiving;

// 性能相关
@property (nonatomic, strong) XMPPCapabilities                    * xmppCapabilities;
@property (nonatomic, strong) XMPPCapabilitiesCoreDataStorage     * xmppCapailitiesStorage;

//  文件发送
@property (nonatomic, strong) XMPPOutgoingFileTransfer            *xmppOutgoingFileTransfer;
//  文件接收
@property (nonatomic, strong) XMPPIncomingFileTransfer            *xmppIncomingFileTransfer;

//添加vCard模块
@property (nonatomic ,strong) XMPPvCardCoreDataStorage            *vCardStorage;
@property (nonatomic ,strong) XMPPvCardTempModule                 *vCardModule;
@property (nonatomic ,strong) XMPPvCardAvatarModule               *vCardAvatorModule;

@property (nonatomic ,copy  ) IMXMPPSuccessBlock                  changeAvatarPhoto;//  修改头像

+ (IMXMPPHelper *)sharedHelper;

@end


@interface IMXMPPHelper(Class)
+ (XMPPJID *)jid:(NSString *)userName;
+ (IMUser *)storageObjectConverUser:(XMPPUserMemoryStorageObject *)item;
@end


@interface IMXMPPHelper (Auth)
//  用户授权
-(void)userAuth;

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
 注册
 
 @param userName 用户名
 @param password 密码
 @param success c登录成功后的回调
 @param fail 失败后的回调
 */
-(void)registerWithName:(NSString *)userName
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
@end


@interface IMXMPPHelper(Roster)
/**
 * 添加好友
 * @param user 该好友的个人信息
 */
- (void)addFriend:(IMUser *)user
          success:(IMXMPPSuccessBlock)success
             fail:(IMXMPPFailBlock)fail;

- (void)removeUser:(IMUser *)user;

/**
 * 同意订阅请求用户，执行被添加好友的操作
 */
-(void)acceptPresenceSubscriptionRequestFrom:(XMPPJID *)fromJid;
-(void)acceptPresenceSubscriptionRequestFrom:(XMPPJID *)fromJid block:(void(^_Nullable)(void))block;

/**
 * 拒接订阅请求，用户拒绝被添加好友的操作
 */
-(void)rejectPresenceSubscriptionRequestFrom:(XMPPJID *)fromJid;
-(void)rejectPresenceSubscriptionRequestFrom:(XMPPJID *)fromJid block:(void(^ _Nullable )(void))block;

/**
 好友改变的回调
 
 @param observer 监听对象
 @param usingBlock 回调
 */
- (void)addRosterChangeNotificationObserver:(id)observer usingBlock:(void(^)(void))usingBlock;

/**
 好友订阅回调
 
 @param observer 监听对象
 @param usingBlock 回调
 */
- (void)addSubscriptionRequestNotificationObserver:(id)observer usingBlock:(void(^)(XMPPPresence *presence))usingBlock;

@end


@interface IMXMPPHelper (message)

/**
 根据jid 查找消息俩表

 @param jid  要查询的jid
 @return XMPPMessageArchiving_Message_CoreDataObject 数组
 */
- (NSArray<XMPPMessageArchiving_Message_CoreDataObject *> *)fetchedMessagesOfJid:(XMPPJID *)jid;

/**
 *  发送消息
 *
 *  @param message 消息内容
 *  @param jid     发送对方的ID
 */
//- (void)sendMessageModel:(IMMessageModel *)message to:(XMPPJID *)jid;

/**
 监听已经接收到的消息
 */
- (void)addChatDidReceiveMessageNotificationObserver:(id)observer usingBlock:(void(^)(void))usingBlock;

/**
 监听当前聊天窗口接收到的消息
 */
- (void)addChatUserDidReceiveMessageNotificationObserver:(id)observer userJid:(XMPPJID *)jid usingBlock:(void(^)(void))usingBlock;

/**
 监听发送成功的消息
 */
- (void)addChatDidSendMessageNotificationObserver:(id)observer usingBlock:(void(^)(void))usingBlock;

/**
 监听发送失败的消息
 */
- (void)addChatDidFailToSendMessageNotificationObserver:(id)observer usingBlock:(void(^)(void))usingBlock;

/**
 监听当前聊天用户发送失败的消息
 */
- (void)addhatUserDidFailToSendMessageNotificationObserver:(id)observer userJid:(XMPPJID *)jid usingBlock:(void(^)(void))usingBlock;
@end


@interface IMXMPPHelper(File)
@end

@interface IMXMPPHelper(VCard)
/**
 我的头像
 */
- (UIImage *)myAvatar;

/**
 修改我的头像
 */
- (void)updateMyAvatar:(UIImage *)image;

/**
 根据jid获取头像
 */
- (UIImage *)userAvatarForJid:(XMPPJID *)jid;

@end
NS_ASSUME_NONNULL_END
