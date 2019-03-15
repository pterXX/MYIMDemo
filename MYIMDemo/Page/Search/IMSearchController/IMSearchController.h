//
//  TLSearchController.h
//  TLChat
//
//  Created by 李伯坤 on 16/3/7.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMSearchResultControllerProtocol.h"

@interface IMSearchController : UISearchController

@property (nonatomic, assign) BOOL enableVoiceInput;

+ (IMSearchController *)createWithResultsContrller:(UIViewController<IMSearchResultControllerProtocol> *)resultVC;

@end
