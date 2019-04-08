//
//  IMFlexibleLayoutViewController+EditExtension.m
//  zhuanzhuan
//
//  Created by 李伯坤 on 2017/8/15.
//  Copyright © 2017年 转转. All rights reserved.
//

#import "IMFlexibleLayoutViewController+EditExtension.h"
#import "IMFLEXEditModelProtocol.h"

@implementation IMFlexibleLayoutViewController (EditExtension)

- (NSError *)checkInputlegitimacy
{
    NSArray *data = self.dataModelArray.all();
    for (id<IMFLEXEditModelProtocol> model in data) {
        if ([model respondsToSelector:@selector(checkInputlegitimacy)]) {
            NSError *error = [model checkInputlegitimacy];
            if (error) {
                return error;
            }
        }
    }
    
    return nil;
}

- (void)excuteCompleteAction
{
    NSArray *data = self.dataModelArray.all();
    for (id<IMFLEXEditModelProtocol> model in data) {
        if ([model respondsToSelector:@selector(excuteCompleteAction)]) {
            [model excuteCompleteAction];
        }
    }
}

@end
