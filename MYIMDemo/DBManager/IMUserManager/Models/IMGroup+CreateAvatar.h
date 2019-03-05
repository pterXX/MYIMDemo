//
//  IMGroup+CreateAvatar.h
//  IMChat
//
//  Created by 徐世杰 on 2017/9/19.
//  Copyright © 2017年 徐世杰. All rights reserved.
//

#import "IMGroup.h"

@interface IMGroup (CreateAvatar)

- (void)createGroupAvatarWithCompleteAction:(void (^)(NSString *groupID))completeAction;

@end
