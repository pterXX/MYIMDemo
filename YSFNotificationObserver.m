//
//  YSFNotificationObserver.m
//  YunShiFinance
//
//  Created by Apple on 2018/9/28.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "YSFNotificationObserver.h"
#import <objc/runtime.h>


#pragma GCC diagnostic ignored "-Wobjc-missing-property-synthesis"
#pragma GCC diagnostic ignored "-Wselector"
#pragma GCC diagnostic ignored "-Wgnu"


#import <Availability.h>
#if !__has_feature(objc_arc) || !__has_feature(objc_arc_weak)
#error This class requires automatic reference counting and weak references
#endif


typedef void (^YSFNotificationBlock)(NSNotification *note, id observer);


static NSMutableArray *YSFNotificationsGetObservers(id object, BOOL create)
{
    @synchronized(object)
    {
        static void *key = &key;
        NSMutableArray *wrappers = objc_getAssociatedObject(object, key);
        if (!wrappers && create)
        {
            wrappers = [NSMutableArray array];
            objc_setAssociatedObject(object, key, wrappers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        return wrappers;
    }
}


@interface YSFNotificationObserver : NSObject

@property (nonatomic, weak) NSObject *observer;
@property (nonatomic, weak) NSObject *object;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) YSFNotificationBlock block;
@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, weak) NSNotificationCenter *center;

- (void)action:(NSNotification *)note;

@end


@implementation YSFNotificationObserver

- (void)action:(NSNotification *)note
{
    __strong id strongObserver = self.observer;
    if (self.block && strongObserver)
    {
        if (!self.queue || [NSOperationQueue currentQueue] == self.queue)
        {
            self.block(note, strongObserver);
        }
        else
        {
            [self.queue addOperationWithBlock:^{
                self.block(note, strongObserver);
            }];
        }
    }
}

- (void)dealloc
{
    __strong NSNotificationCenter *strongCenter = _center;
    [strongCenter removeObserver:self];
}

@end


@implementation NSNotificationCenter (YSFNotifications)

+ (void)load
{
    SEL original = @selector(removeObserver:name:object:);
    SEL replacement = @selector(YSFNotification_removeObserver:name:object:);
    method_exchangeImplementations(class_getInstanceMethod(self, original),
                                   class_getInstanceMethod(self, replacement));
}

- (id)addObserver:(id)observer
          forName:(nullable NSString *)name
           object:(nullable id)object
            queue:(nullable NSOperationQueue *)queue
       usingBlock:(YSFNotificationBlock)block
{
    YSFNotificationObserver *container = [[YSFNotificationObserver alloc] init];
    container.observer = observer;
    container.object = object;
    container.name = name;
    container.block = block;
    container.queue = queue;
    container.center = self;
    
    [YSFNotificationsGetObservers(observer, YES) addObject:container];
    [self addObserver:container selector:@selector(action:) name:name object:object];
    return container;
}

- (void)YSFNotification_removeObserver:(id)observer name:(NSString *)name object:(id)object
{
    for (YSFNotificationObserver *container in [YSFNotificationsGetObservers(observer, NO) reverseObjectEnumerator])
    {
        __strong id strongObject = container.object;
        if (container.center == self &&
            (!container.name || !name || [container.name isEqualToString:name]) &&
            (!strongObject || !object || strongObject == object))
        {
            [YSFNotificationsGetObservers(observer, NO) removeObject:container];
        }
    }
    if (object_getClass(observer) == [YSFNotificationObserver class])
    {
        YSFNotificationObserver *container = observer;
        __strong NSObject *strongObserver = container.observer;
        [YSFNotificationsGetObservers(strongObserver, NO) removeObject:container];
    }
    [self YSFNotification_removeObserver:observer name:name object:object];
}

@end
