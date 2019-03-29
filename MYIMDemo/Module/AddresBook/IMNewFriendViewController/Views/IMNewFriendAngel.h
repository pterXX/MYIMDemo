//
//  IMNewFriendAngel.h
//  MYIMDemo
//
//  Created by admin on 2019/3/15.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "IMFlexAngel.h"

NS_ASSUME_NONNULL_BEGIN

@interface IMNewFriendAngel : IMFLEXAngel
/// pushAction
@property (nonatomic, copy) void (^pushAction)(__kindof UIViewController *vc);
@property (nonatomic, copy) void (^btnAction)(void);

- (void)resetListWithContactsData:(NSArray *)contactsData;

- (instancetype)initWithHostView:(__kindof UIScrollView *)hostView pushAction:(void (^)(__kindof UIViewController *vc))pushAction;
@end

NS_ASSUME_NONNULL_END
