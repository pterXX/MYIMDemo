//
//  IMNewFriendAngel.m
//  MYIMDemo
//
//  Created by admin on 2019/3/15.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "IMNewFriendAngel.h"
#import "IMMobileContactsViewController.h"
#import "IMAddContactsViewController.h"
#import "IMNewFriendFuncationCell.h"
#import "IMNewFriendViewUserCell.h"
#import "IMFriendFindViewController.h"
#import "IMUserGroup.h"


typedef NS_ENUM(NSInteger, IMNewFriendVCSectionType) {
    IMNewFriendVCSectionTypeFuncation = -1,
    IMNewFriendVCSectionTypeUser
};


@interface IMNewFriendAngel ()<IMNewFriendCellDelegate>

@end

@implementation IMNewFriendAngel

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
    NSMutableArray *userArray = [contactsData zh_enumerateObjectsUsingBlock:^id _Nonnull(XMPPJID * _Nonnull obj) {
        return [IMUser user:obj];
    }].mutableCopy;
    IMUserGroup *group1 = [[IMUserGroup alloc] initWithGroupName:@"好友申请" users:userArray];
    group1.tag = IMNewFriendVCSectionTypeUser;
    NSArray *groupArray = @[group1];
    
    @weakify(self);
    self.clear();
    self.addSection(IMNewFriendVCSectionTypeFuncation);
    IMNewFriendFuncationModel *model = createNewFriendFuncationModel(@"newFriend_contacts", @"添加手机联系人");
    self.addCell(@"IMNewFriendFuncationCell").toSection(IMNewFriendVCSectionTypeFuncation).withDataModel(model).selectedAction(^(id data){
        @strongify(self);
        IMMobileContactsViewController *contactsVC = [[IMMobileContactsViewController alloc] init];
        [self tryPushVC:contactsVC];
    });
    
    self.addSection(IMNewFriendVCSectionTypeUser);
    IMNewFriendItem *(^createNewFriendItemModelWithUserModel)(IMUser *userModel) = ^IMNewFriendItem *(IMUser *userModel){
        IMNewFriendItem *model = createNewFriendItemModel(userModel.avatarPath, userModel.avatarURL, userModel.showName, userModel.detailInfo.remarkInfo, userModel);
        return model;
    };
    for (IMUserGroup *group in groupArray) {
        NSInteger sectionTag = group.tag;
        self.addSection(sectionTag);
        self.setHeader(@"IMContactsHeaderView").toSection(sectionTag).withDataModel(group.groupName);
        
        NSMutableArray *data = [[NSMutableArray alloc]initWithCapacity:group.users.count];
        for (IMUser *user in group.users) {
            IMNewFriendItem *newModel = createNewFriendItemModelWithUserModel(user);
            [data addObject:newModel];
        }
        self.addCells(NSStringFromClass([IMNewFriendViewUserCell class])).toSection(sectionTag).withDataModelArray(data).delegate(self);
    }
}

- (void)tryPushVC:(__kindof UIViewController *)vc
{
    if (self.pushAction) {
        self.pushAction(vc);
    }
}

- (void)tryBtnAction
{
    if (self.btnAction) {
        self.btnAction();
    }
}


- (void)newFriendCell:(nonnull IMNewFriendViewUserCell *)cell agreeButDidTouchUp:(nonnull IMUser *)user {
    @weakify(self);
    [KIMXMPPHelper acceptPresenceSubscriptionRequestFrom:user.userJid block:^{
        @strongify(self);
        [SVProgressHUD showInfoWithStatus:IMStirngFormat(@"成功添加:%@成为了好友",user.userJid.user)];
        [SVProgressHUD dismissWithDelay:1.5];
        [self tryBtnAction];
    }];
}

- (void)newFriendCell:(nonnull IMNewFriendViewUserCell *)cell rejectButDidTouchUp:(nonnull IMUser *)user {
    @weakify(self);
    [KIMXMPPHelper rejectPresenceSubscriptionRequestFrom:user.userJid block:^{
        @strongify(self);
        [SVProgressHUD showInfoWithStatus:IMStirngFormat(@"你已拒绝了:%@的好友请求",user.userJid.user)];
        [SVProgressHUD dismissWithDelay:1.5];
        [self tryBtnAction];
    }];
}

@end
