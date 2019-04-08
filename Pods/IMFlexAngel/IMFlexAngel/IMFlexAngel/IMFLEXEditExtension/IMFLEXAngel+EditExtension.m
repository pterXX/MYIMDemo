//
//  IMFLEXAngel+EditExtension.m
//  IMFLEXDemo
//
//  Created by 李伯坤 on 2018/2/5.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import "IMFLEXAngel+EditExtension.h"
#import "IMFLEXEditModelProtocol.h"

@implementation IMFLEXAngel (EditExtension)

- (NSError *)checkInputlegitimacy
{
    for (id<IMFLEXEditModelProtocol> model in self.dataModelArray.all()) {
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
    for (id<IMFLEXEditModelProtocol> model in self.dataModelArray.all()) {
        if ([model respondsToSelector:@selector(excuteCompleteAction)]) {
            [model excuteCompleteAction];
        }
    }
}

@end
