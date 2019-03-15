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
        self.addCells(NSStringFromClass([IMNewFriendViewUserCell class])).toSection(sectionTag).withDataModelArray(data).selectedAction(^ (IMNewFriendItem *data) {
            IMUser *user = data.userInfo;
        });
    }
}

- (void)tryPushVC:(__kindof UIViewController *)vc
{
    if (self.pushAction) {
        self.pushAction(vc);
    }
}

@end
