//
//  IMDBConversationsSQL.h
//  MYIMDemo
//
//  Created by admin on 2019/3/19.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#ifndef IMDBConversationsSQL_h
#define IMDBConversationsSQL_h
#define     CONVERSATIONS_TABLE_NAME              @"Conversations3"

#define     SQL_CREATE_CONVERSATIONS_TABLE        @"CREATE TABLE IF NOT EXISTS %@(\
uid TEXT,\
conversationId TEXT,\
chatType TEXT,\
msgid TEXT,\
user TEXT,\
domain TEXT, \
avatar TEXT,\
resource TEXT,\
name TEXT,\
badgeNumber TEXT,\
msgType TEXT,\
messageChatType TEXT,\
direction TEXT,\
messageReadStatus TEXT,\
toUserName TEXT,\
toUserId TEXT,\
toUserAvatar TEXT,\
recvTime TEXT,\
content TEXT,\
ext1 TEXT,\
ext2 TEXT,\
ext3 TEXT,\
PRIMARY KEY(uid))"

#define     SQL_UPDATE_CONVERSATION               @"REPLACE INTO %@ ( uid,conversationId,chatType, msgid, user, domain, avatar, resource, name, badgeNumber, msgType, messageChatType, direction,messageReadStatus,toUserName,toUserId,toUserAvatar,recvTime,content,ext1,ext2,ext3) VALUES ( ?,?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"

#define     SQL_SELECT_CONVERSATIONS              @"SELECT * FROM %@ WHERE uid = '%@'"

#define     SQL_DELETE_CONVERSATION               @"DELETE FROM %@ WHERE uid = '%@' and conversationId = '%@'"

#endif /* IMDBConversationsSQL_h */
