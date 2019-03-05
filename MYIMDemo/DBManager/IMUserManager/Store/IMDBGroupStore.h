//
//  IMDBGroupStore.h
//  IMChat
//
//  Created by 徐世杰 on 16/4/17.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "IMDBBaseStore.h"
#import "IMGroup.h"

@interface IMDBGroupStore : IMDBBaseStore

- (BOOL)updateGroupsData:(NSArray *)groupData
                   forUid:(NSString *)uid;

- (BOOL)addGroup:(IMGroup *)group forUid:(NSString *)uid;


- (NSMutableArray *)groupsDataByUid:(NSString *)uid;

- (BOOL)deleteGroupByGid:(NSString *)gid forUid:(NSString *)uid;

@end
