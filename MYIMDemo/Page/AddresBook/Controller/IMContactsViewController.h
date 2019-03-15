//
//  IMAddressBookViewController.h
//  MYIMDemo
//
//  Created by admin on 2019/3/11.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "IMBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface IMContactsViewController : IMBaseViewController

@end

@interface IMContactsViewController(Class)
+ (IMBaseNavigationController *)navAddressBookVc;
@end
NS_ASSUME_NONNULL_END
