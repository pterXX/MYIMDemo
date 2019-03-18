//
//  IMLoginViewController.h
//  MYIMDemo
//
//  Created by admin on 2019/3/5.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMBaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface IMLoginViewController : IMBaseViewController
@property (nonatomic ,copy) void(^loginSuccess)(void);
@end

NS_ASSUME_NONNULL_END
