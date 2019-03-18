//
//  TLSearchController.h
//  TLChat
//
//  Created by 徐世杰 on 16/3/7.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMSearchResultControllerProtocol.h"

@interface IMSearchController : UISearchController

@property (nonatomic, assign) BOOL enableVoiceInput;

+ (IMSearchController *)createWithResultsContrller:(UIViewController<IMSearchResultControllerProtocol> *)resultVC;

@end
