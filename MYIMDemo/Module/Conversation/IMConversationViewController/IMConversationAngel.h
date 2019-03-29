//
//  IMConversationAngel.h
//  IMChat
//
//  Created by 徐世杰 on 2017/12/26.
//  Copyright © 2017年 徐世杰. All rights reserved.
//

#import <IMFlexAngel/IMFlexibleLayoutFramework.h>

typedef NS_ENUM(NSInteger, IMConversationSectionTag) {
    IMConversationSectionTagAlert,
    IMConversationSectionTagTopArticle,
    IMConversationSectionTagPlay,
    IMConversationSectionTagTopConversation,
    IMConversationSectionTagConv,
};

typedef NS_ENUM(NSInteger, IMConversationCellTag) {
    IMConversationCellTagNoNet,
};


@interface IMConversationAngel : IMFLEXAngel <
    UITableViewDelegate
>

@property (nonatomic, copy) void (^badgeStatusChangeAction)(NSString *badge);

- (instancetype)initWithHostView:(__kindof UIScrollView *)hostView badgeStatusChangeAction:(void (^)(NSString *badge))badgeStatusChangeAction;

- (void)reloadBadge;

@end
