//
//  IMConversationAngel.h
//  MYIMDemo
//
//  Created by admin on 2019/3/19.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "IMFlexAngel.h"

NS_ASSUME_NONNULL_BEGIN


@interface IMConversationAngel : IMFlexAngel
/// pushAction
@property (nonatomic, copy) void (^pushAction)(__kindof UIViewController *vc);
@property (nonatomic, copy) void (^deleteAction)(__kindof NSIndexPath *indexPath);
// 记录正在聊天的会话
@property (nonatomic, strong) NSString           *conversationId;

- (void)resetListWithContactsData:(NSArray *)contactsData;

- (instancetype)initWithHostView:(__kindof UIScrollView *)hostView pushAction:(void (^)(__kindof UIViewController *vc))pushAction;
@end

NS_ASSUME_NONNULL_END
