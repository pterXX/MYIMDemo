//
//  NSObject+Dealloc.h
//  IMChat
//
//  Created by 李伯坤 on 2017/7/12.
//  Copyright © 2017年 李伯坤. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^IMDeallocBlock)(void);

@interface NSObject (Dealloc)

- (void)addDeallocTask:(IMDeallocBlock)deallocTask forTarget:(id)target key:(NSString *)key;

- (void)removeDeallocTaskForTarget:(id)target key:(NSString *)key;

@end
