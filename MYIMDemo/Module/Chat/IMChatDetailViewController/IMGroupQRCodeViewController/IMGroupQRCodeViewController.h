//
//  IMGroupQRCodeViewController.h
//  IMChat
//
//  Created by 徐世杰 on 16/3/8.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "IMBaseViewController.h"
#import "IMGroup.h"

@interface IMGroupQRCodeViewController : IMBaseViewController

@property (nonatomic, strong) IMGroup *group;

- (instancetype)initWithGroupModel:(IMGroup *)groupModel;
- (instancetype)init NS_UNAVAILABLE;

@end
