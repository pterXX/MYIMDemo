//
//  IMDBFriendSQL.h
//  IMChat
//
//  Created by 徐世杰 on 16/3/22.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#ifndef IMDBFriendSQL_h
#define IMDBFriendSQL_h

#define     FRIENDS_TABLE_NAME              @"friends"

#define     SQL_CREATE_FRIENDS_TABLE        @"CREATE TABLE IF NOT EXISTS %@(\
                                            uid TEXT,\
                                            fid TEXT,\
                                            username TEXT,\
                                            nikename TEXT, \
                                            avatar TEXT,\
                                            remark TEXT,\
                                            ext1 TEXT,\
                                            ext2 TEXT,\
                                            ext3 TEXT,\
                                            ext4 TEXT,\
                                            ext5 TEXT,\
                                            PRIMARY KEY(uid, fid))"

#define     SQL_UPDATE_FRIEND               @"REPLACE INTO %@ ( uid, fid, username, nikename, avatar, remark, ext1, ext2, ext3, ext4, ext5) VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"

#define     SQL_SELECT_FRIENDS              @"SELECT * FROM %@ WHERE uid = %@"

#define     SQL_DELETE_FRIEND               @"DELETE FROM %@ WHERE uid = '%@' and fid = '%@'"

#endif /* IMDBFriendSQL_h */
