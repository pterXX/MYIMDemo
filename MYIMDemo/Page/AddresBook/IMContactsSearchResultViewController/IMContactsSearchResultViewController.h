//
//  TLContactsSearchResultViewController.h
//  TLChat
//
//  Created by 徐世杰 on 16/1/25.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "IMSearchResultControllerProtocol.h"
#import "IMSearchController.h"

#define     HEIGHT_FRIEND_CELL      54.0f

@class IMUser;
@interface IMContactsSearchResultViewController : IMBaseViewController <IMSearchResultControllerProtocol>

@property (nonatomic, copy) void (^itemSelectedAction)(IMContactsSearchResultViewController *searchVC, IMUser *userModel);

@end
