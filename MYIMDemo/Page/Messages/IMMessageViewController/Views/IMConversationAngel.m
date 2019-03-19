//
//  IMConversationAngel.m
//  MYIMDemo
//
//  Created by admin on 2019/3/19.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "IMConversationAngel.h"
#import "IMConversationListTableViewCell.h"
#import "IMChatViewController.h"
#import "IMConversationModel.h"


@implementation IMConversationAngel
- (instancetype)initWithHostView:(__kindof UIScrollView *)hostView pushAction:(void (^)(__kindof UIViewController *vc))pushAction
{
    if (self = [super initWithHostView:hostView]) {
        self.pushAction = pushAction;
    }
    return self;
}

- (void)resetListWithContactsData:(NSArray *)contactsData
{
   self.clear();
    @weakify(self);
    if (contactsData) {
        self.addSection(1);
        self.addCells(NSStringFromClass([IMConversationListTableViewCell class])).toSection(1).withDataModelArray(contactsData).selectedAction(^ (IMConversationModel *data) {
            @strongify(self);
            self.conversationId                 = data.conversationId;
            IMChatViewController *chatCtrl      = [IMChatViewController new];
            chatCtrl.title                      = data.conversationName;
            chatCtrl.hidesBottomBarWhenPushed   = YES;
            chatCtrl.conversation               = data;
            chatCtrl.isConversationInto         = YES;
            [self tryPushVC:chatCtrl];
        });
    }
}

- (void)tryPushVC:(__kindof UIViewController *)vc{
    if (self.pushAction) {
        self.pushAction(vc);
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.deleteAction?YES:NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.deleteAction ? UITableViewCellEditingStyleDelete:UITableViewCellEditingStyleNone;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *arr = [NSMutableArray array];
    if (self.deleteAction) {
        UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            if (self.deleteAction) {
                self.deleteAction(indexPath);
                //  因为执行delete 的操作所以这句代代码废弃
//                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
            }
        }];
        action.backgroundColor = [UIColor redColor];
        [arr addObject:action];
    }
    return arr;
}

@end
