//
//  IMDeallocTask.m
//  IMChat
//
//  Created by 李伯坤 on 2017/7/12.
//  Copyright © 2017年 李伯坤. All rights reserved.
//

#import "IMDeallocTask.h"

#pragma mark - ## IMDeallocTaskItem
@interface IMDeallocTaskItem : NSObject

@property (nonatomic, weak, readonly) id target;
@property (nonatomic, copy, readonly) NSString *key;
@property (nonatomic, copy, readonly) IMDeallocBlock task;

- (instancetype)initWithTarget:(id)target key:(NSString *)key task:(IMDeallocBlock)task;

@end

@implementation IMDeallocTaskItem

- (instancetype)initWithTarget:(id)target key:(NSString *)key task:(IMDeallocBlock)task
{
    self = [super init];
    if (self) {
        _target = target;
        _key = key;
        _task = [task copy];
    }
    return self;
}

- (BOOL)isEqual:(IMDeallocTaskItem *)object
{
    if (object == self) {
        return YES;
    }
    else if ([object isKindOfClass:[self class]] && [object.target isEqual:self.target] && [object.key isEqualToString:self.key]) {
        return YES;
    }
    return NO;
}

- (NSUInteger)hash
{
    return ([self.target hash] + self.key.hash) / 2;
}

@end

#pragma mark - ## IMDeallocTask
@interface IMDeallocTask ()

@property (nonatomic, strong) NSMutableSet<IMDeallocTaskItem *> *taskSet;

@end

@implementation IMDeallocTask

- (id)init
{
    if (self = [super init]) {
        self.taskSet = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [self.taskSet enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(IMDeallocTaskItem *obj, BOOL *stop) {
        obj.task ? obj.task() : nil;
    }];
}

#pragma mark - # Public Methods
- (void)addTask:(IMDeallocBlock)task forTarget:(id)target key:(NSString *)key
{
    IMDeallocTaskItem *taskItem = [[IMDeallocTaskItem alloc] initWithTarget:target key:key task:task];
    if ([self.taskSet containsObject:taskItem]) {
        [self.taskSet removeObject:taskItem];
    }
    [self.taskSet addObject:taskItem];
}

- (void)removeTaskForTarget:(id)target key:(NSString *)key
{
    IMDeallocTaskItem *taskItem = [[IMDeallocTaskItem alloc] initWithTarget:target key:key task:nil];
    [self.taskSet removeObject:taskItem];
}

@end
