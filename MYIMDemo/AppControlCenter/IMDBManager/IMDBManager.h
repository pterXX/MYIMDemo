//
//  IMDBManager.h
//  IMChat
//
//  Created by 徐世杰 on 16/3/13.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>

@interface IMDBManager : NSObject

/**
 *  DB队列（除IM相关）
 */
@property (nonatomic, strong) FMDatabaseQueue *commonQueue;

/**
 *  与IM相关的DB队列
 */
@property (nonatomic, strong) FMDatabaseQueue *messageQueue;

+ (IMDBManager *)sharedInstance;

@end
