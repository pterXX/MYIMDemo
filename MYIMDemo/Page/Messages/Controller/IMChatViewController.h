//
//  IMChatViewController.h
//  MYIMDemo
//
//  Created by 徐世杰 on 2019/3/1.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "IMChatBaseViewController.h"
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN
@class IMConversationModel;
@class IMMessageModel;
@interface IMChatViewController : IMChatBaseViewController<AVAudioPlayerDelegate>
// 进入聊天页面需要发送正处于发送状态的消息
@property (nonatomic, assign) BOOL               isEnterSend;
@property (nonatomic, assign) BOOL               canceled;
// 消息列表
@property (nonatomic, strong) UITableView        *listView;
// 记录图片和视频数据
@property (nonatomic, strong) NSMutableArray     *allImageDatas;
// 数据源
@property (nonatomic, strong) NSMutableArray     *dataSource;
// 会话
@property (nonatomic, strong) IMConversationModel *conversation;
// 是否是从会话页面进入
@property (nonatomic, assign) BOOL               isConversationInto;
// 最后播放的语音URL的Index
@property (nonatomic, assign) NSInteger          lastPlayVoiceIndex;

// 重新刷新数据
- (void)reloadData;
// 移动到底部
- (void)scrollTableViewBottom ;
// 添加一条消息
- (void)addMessage:(IMMessageModel *)model;
// 最后一条消息
- (IMMessageModel *)lastMessage;

/**
 移除一条消息
 
 @param message 消息
 */
- (void)removeLastMessage:(IMMessageModel *)message;

/**
 最新消息是否显示时间
 
 @param messageModel 最新的消息
 @return YES：显示 NO:不显示
 */
- (BOOL)isShowTimeWithNewMessageModel:(IMMessageModel *)messageModel previousMessage:(IMMessageModel *)previousMessage;

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
                    saveResult:(void(^)(BOOL isSuccess, NSDictionary *jsonDic, NSString *localMsgId))saveResult;
/**
 发送消息
 
 @param jsonStr 消息json字符串
 @param localMessageId 本地消息id
 @param indexPath 当条消息所在行数据
 */
- (void)sendMessageWithJsonStr:(NSString *)jsonStr
                localMessageId:(NSString *)localMessageId
                     indexPath:(NSIndexPath *)indexPath;

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
                   serversMsgId:(NSString *)serversMsgId;


/**
 更新本地消息发送状态
 
 @param srcId 本地消息id
 @param destId 服务器返回消息id
 @param sendState 消息状态，0：失败，1：成功 2:发送中
 */
- (void)updateDatabaseMessageWithSrcId:(NSString *)srcId
                                destId:(NSString *)destId
                             sendState:(int)sendState;
@end

NS_ASSUME_NONNULL_END
