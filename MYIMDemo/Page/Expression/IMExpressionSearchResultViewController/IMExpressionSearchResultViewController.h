//
//  IMExpressionSearchResultViewController.h
//  IMChat
//
//  Created by 李伯坤 on 16/4/4.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "IMBaseViewController.h"
#import "IMSearchResultControllerProtocol.h"

@interface IMExpressionSearchResultViewController : IMBaseViewController <IMSearchResultControllerProtocol>

@property (nonatomic, copy) void (^itemClickAction)(IMExpressionSearchResultViewController *searchController, id data);

@end
