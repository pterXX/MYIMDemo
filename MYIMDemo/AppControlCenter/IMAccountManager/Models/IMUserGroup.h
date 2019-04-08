//
//  IMUserGroup.h
//  IMChat
//
//  Created by 徐世杰 on 16/1/26.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMUser.h"

@interface IMUserGroup : NSObject

/// tag
@property (nonatomic, assign) NSInteger tag;

@property (nonatomic, strong) NSString *groupName;

@property (nonatomic, strong) NSMutableArray *users;

@property (nonatomic, assign, readonly) NSInteger count;

- (id)initWithGroupName:(NSString *)groupName users:(NSMutableArray *)users;

- (void)addObject:(id)anObject;

- (id)objectAtIndex:(NSUInteger)index;

@end
