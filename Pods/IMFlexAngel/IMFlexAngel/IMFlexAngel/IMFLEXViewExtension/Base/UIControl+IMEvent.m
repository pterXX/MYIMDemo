//
//  UIControl+IMEvent.m
//  IMFLEXDemo
//
//  Created by 李伯坤 on 2017/11/27.
//  Copyright © 2017年 李伯坤. All rights reserved.
//

#import "UIControl+IMEvent.h"
#import <objc/runtime.h>

static const int IM_CONTROL_TARGETS_KEY;

@interface IMControlTarget : NSObject

@property (nonatomic, copy) void (^senderBlock)(id sender);
@property (nonatomic, assign) UIControlEvents controlEvents;

- (instancetype)initWithSenderBlock:(void (^)(id sender))senderBlock
                      controlEvents:(UIControlEvents)controlEvents;
- (void)senderMethod:(id)sender;

@end

@implementation IMControlTarget

- (instancetype)initWithSenderBlock:(void (^)(id sender))senderBlock
                      controlEvents:(UIControlEvents)controlEvents {
    if (self = [super init]) {
        _senderBlock   = senderBlock;
        _controlEvents = controlEvents;
    }
    return self;
}

- (void)senderMethod:(id)sender {
    if (_senderBlock) { _senderBlock(sender); }
}

@end


@implementation UIControl (IMEvent)

- (void)addControlEvents:(UIControlEvents)controlEvents
                 handler:(void (^)(id sender))handlerBlock {
    if (!controlEvents) return;
    IMControlTarget *controlTarget = [[IMControlTarget alloc] initWithSenderBlock:handlerBlock
                                                                    controlEvents:controlEvents];
    [self addTarget:controlTarget action:@selector(senderMethod:) forControlEvents:controlEvents];
    NSMutableArray *controlTargets = [self controlTargets];
    [controlTargets addObject:controlTarget];
}

- (void)removeControlEvents:(UIControlEvents)controlEvents {
    if (!controlEvents) return;
    NSMutableArray *controlTargets = [self controlTargets];
    for (IMControlTarget *controlTarget in controlTargets) {
        if (controlTarget.controlEvents == controlEvents) {
            [self removeTarget:controlTarget action:@selector(senderMethod:) forControlEvents:controlEvents];
        }
    }
}

- (NSMutableArray *)controlTargets {
    NSMutableArray *controlTargets = objc_getAssociatedObject(self, &IM_CONTROL_TARGETS_KEY);
    if (!controlTargets) {
        controlTargets = @[].mutableCopy;
        objc_setAssociatedObject(self, &IM_CONTROL_TARGETS_KEY, controlTargets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return controlTargets;
}

@end
