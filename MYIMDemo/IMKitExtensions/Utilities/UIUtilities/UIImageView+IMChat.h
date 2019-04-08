//
//  UIImageView+IMChat.h
//  MYIMDemo
//
//  Created by admin on 2019/3/20.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMXMPPHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (IMChat)
- (void)im_setAvatar:(NSString *)userAvatar jid:(XMPPJID *)jid;
@end

NS_ASSUME_NONNULL_END
