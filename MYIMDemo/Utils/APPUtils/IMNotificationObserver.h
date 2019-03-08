//
//  IMNotificationObserver.h
//  YunShiFinance
//
//  Created by Apple on 2018/9/28.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wobjc-missing-property-synthesis"

@interface NSNotificationCenter (IMNotifications)

- (id)addObserver:(id)observer
          forName:(nullable NSString *)name
           object:(nullable id)object
            queue:(nullable NSOperationQueue *)queue
       usingBlock:(void (^)(NSNotification *note, id observer))block;

@end

#pragma GCC diagnostic pop

NS_ASSUME_NONNULL_END
