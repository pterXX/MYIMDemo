//
//  IMMessageViewController.h
//  MYIMDemo
//
//  Created by 徐世杰 on 2019/2/28.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "IMBaseViewController.h"

@interface IMConversationViewController : IMBaseViewController


@end


@interface IMConversationViewController(Class)
+ (IMBaseNavigationController *)navMessagesVc;
@end
