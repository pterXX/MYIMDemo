//
//  IMConversationStore.m
//  MYIMDemo
//
//  Created by admin on 2019/3/19.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "IMDBConversationStore.h"
#import "IMDBConversationsSQL.h"
#import "IMConversationModel.h"
@implementation IMDBConversationStore

- (id)init
{
    if (self = [super init]) {
        self.dbQueue = [IMDBManager sharedInstance].commonQueue;
        BOOL ok = [self createTable];
        if (!ok) {
            DDLogError(@"DB: 会话表创建失败");
        }
    }
    return self;
}

- (BOOL)createTable
{
    NSString *sqlString = [NSString stringWithFormat:SQL_CREATE_CONVERSATIONS_TABLE, CONVERSATIONS_TABLE_NAME];
    return [self createTable:CONVERSATIONS_TABLE_NAME withSQL:sqlString];
}

- (BOOL)addConversation:(IMConversationModel *)conversation forUid:(NSString *)uid
{
    NSString *sqlString = [NSString stringWithFormat:SQL_UPDATE_CONVERSATION, CONVERSATIONS_TABLE_NAME];
    
    NSArray *arrPara = [NSArray arrayWithObjects:
                        IMNoNilString([IMUserHelper sharedHelper].userID),
                        IMNoNilString(conversation.conversationId),
                        IMIntegerConverStr(conversation.chatType),
                        IMNoNilString(conversation.message.messageId),
                        IMNoNilString(conversation.chatToJid.user),
                        IMNoNilString(conversation.chatToJid.domain),
                        IMNoNilString(conversation.headImage),
                        IMNoNilString(conversation.chatToJid.resource),
                        IMNoNilString(conversation.conversationName),
                        IMIntegerConverStr(conversation.badgeNumber),
                        IMIntegerConverStr(conversation.message.msgType),
                        IMIntegerConverStr(conversation.message.messageChatType),
                        IMIntegerConverStr(conversation.message.direction),
                        IMIntegerConverStr(conversation.message.messageReadStatus),
                        IMNoNilString(conversation.message.toUserName),
                        IMNoNilString(conversation.message.toUserId),
                        IMNoNilString(conversation.message.toUserAvatar),
                        IMNoNilString(conversation.message.recvTime),
                        IMNoNilString(conversation.message.messageBody),
                         @"", @"", @"", nil];
    BOOL ok = [self excuteSQL:sqlString withArrParameter:arrPara];
    return ok;
}

- (BOOL)updateConversationsData:(NSArray *)conversationData forUid:(NSString *)uid
{
    NSArray *oldData = [self conversationsDataByUid:uid];
    if (oldData.count > 0) {
        // 建立新数据的hash表，用于删除数据库中的过时数据
        NSMutableDictionary *newDataHash = [[NSMutableDictionary alloc] init];
        for (IMConversationModel *conversation in conversationData) {
            [newDataHash setValue:@"YES" forKey:conversation.conversationId];
        }
        for (IMConversationModel *conversation in oldData) {
            if ([newDataHash objectForKey:conversation.conversationId] == nil) {
                BOOL ok = [self deleteConversationByFid:conversation.conversationId forUid:uid];
                if (!ok) {
                    DDLogError(@"DBError: 删除过期会话失败");
                }
            }
        }
    }
    
    for (IMConversationModel *conversation in conversationData) {
        BOOL ok = [self addConversation:conversation forUid:uid];
        if (!ok) {
            return ok;
        }
    }
    
    return YES;
}

- (NSMutableArray *)conversationsDataByUid:(NSString *)uid
{
    __block NSMutableArray *data = [[NSMutableArray alloc] init];
    NSString *sqlString = [NSString stringWithFormat:SQL_SELECT_CONVERSATIONS, CONVERSATIONS_TABLE_NAME, uid];
    
    [self excuteQuerySQL:sqlString resultBlock:^(FMResultSet *retSet) {
        while ([retSet next]) {
            IMConversationModel *model = [[IMConversationModel alloc] init];
            model.conversationId   = [retSet stringForColumn:@"conversationId"];
            model.chatType         = [[retSet stringForColumn:@"chatType"] intValue];;
            NSString *resource     = [retSet stringForColumn:@"resource"];
            resource               = resource.length > 0?resource:nil; //  resource 如果字符长度如果为0必须将值赋值为nil，否则jid不能实例化
            model.chatToJid        = [XMPPJID jidWithUser:[retSet stringForColumn:@"user"] domain:[retSet stringForColumn:@"domain"] resource:resource];
            model.headImage        = [retSet stringForColumn:@"avatar"];
            model.conversationName = [retSet stringForColumn:@"name"];
            model.badgeNumber = [[retSet stringForColumn:@"badgeNumber"] intValue];
            
            IMMessageModel *message = [[IMMessageModel alloc] init];
            message.msgJid            = [XMPPJID jidWithUser:[retSet stringForColumn:@"user"] domain:[retSet stringForColumn:@"domain"] resource:resource];
            message.messageId         = [retSet stringForColumn:@"msgid"];
            message.msgType           = [[retSet stringForColumn:@"msgType"] intValue];
            message.messageChatType   = [[retSet stringForColumn:@"messageChatType"] intValue];
            message.direction         = [[retSet stringForColumn:@"direction"] intValue];
            message.messageReadStatus = [[retSet stringForColumn:@"messageReadStatus"] intValue];
            message.toUserName        = [retSet stringForColumn:@"toUserName"];
            message.toUserAvatar      = [retSet stringForColumn:@"toUserAvatar"];
            message.recvTime          = [retSet stringForColumn:@"recvTime"];
            message.content           = [retSet stringForColumn:@"content"];
            model.message = message;
            [data addObject:model];
        }
        [retSet close];
    }];
    
    return data;
}

- (BOOL)deleteConversationByFid:(NSString *)fid forUid:(NSString *)uid
{
    NSString *sqlString = [NSString stringWithFormat:SQL_DELETE_CONVERSATION, CONVERSATIONS_TABLE_NAME, uid, fid];
    BOOL ok = [self excuteSQL:sqlString, nil];
    return ok;
}

@end
