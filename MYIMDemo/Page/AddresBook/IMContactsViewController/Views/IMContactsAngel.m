//
//  IMContactsAngel.m
//  MYIMDemo
//
//  Created by admin on 2019/3/15.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "IMContactItemCell.h"
#import "IMContactsAngel.h"
#import "IMGroupViewController.h"
#import "IMNewFriendViewController.h"
#import "IMOfficialAccountViewController.h"
#import "IMTagsViewController.h"
#import "IMUserDetailViewController.h"

@interface IMContactsAngel()
/// header
@property (nonatomic, strong) NSArray *sectionHeaders;

@end

@implementation IMContactsAngel

- (instancetype)initWithHostView:(__kindof UIScrollView *)hostView pushAction:(void (^)(__kindof UIViewController *vc))pushAction
{
    if (self = [super initWithHostView:hostView]) {
        self.pushAction = pushAction;
    }
    return self;
}

- (void)resetListWithContactsData:(NSArray *)contactsData
{
    kWeakSelf
    self.clear();
    
    /// 功能
    self.addSection(IMContactsVCSectionTypeFuncation);
    {
        IMContactsItem *newModel = createContactsItemModelWithTag(IMContactsVCCellTypeNew, @"plugins_FriendNotify", nil, @"新的朋友", nil, nil);
        IMContactsItem *groupModel = createContactsItemModelWithTag(IMContactsVCCellTypeGroup, @"add_friend_icon_addgroup", nil, @"群聊", nil, nil);
        IMContactsItem *tagModel = createContactsItemModelWithTag(IMContactsVCCellTypeTag, @"Contact_icon_ContactTag", nil, @"标签", nil, nil);
        IMContactsItem *publicModel = createContactsItemModelWithTag(IMContactsVCCellTypePublic, @"add_friend_icon_offical", nil, @"公众号", nil, nil);
        NSArray *funcationData = @[newModel, groupModel, tagModel, publicModel];
        self.addCells(NSStringFromClass([IMContactItemCell class])).toSection(IMContactsVCSectionTypeFuncation).withDataModelArray(funcationData).selectedAction(^ (IMContactsItem *model) {
            if (model.tag == IMContactsVCCellTypeNew) {
                IMNewFriendViewController *newFriendVC = [[IMNewFriendViewController alloc] init];
                [weakSelf tryPushVC:newFriendVC];
            }
            else if (model.tag == IMContactsVCCellTypeGroup) {
                IMGroupViewController *groupVC = [[IMGroupViewController alloc] init];
                [weakSelf tryPushVC:groupVC];
            }
            else if (model.tag == IMContactsVCCellTypeTag) {
                IMTagsViewController *tagsVC = [[IMTagsViewController alloc] init];
                [weakSelf tryPushVC:tagsVC];
            }
            else if (model.tag == IMContactsVCCellTypePublic) {
                IMOfficialAccountViewController *publicServerVC = [[IMOfficialAccountViewController alloc] init];
                [weakSelf tryPushVC:publicServerVC];
            }
        });
    }
    // 企业
    self.addSection(IMContactsVCSectionTypeEnterprise);
    
    // 好友
    IMContactsItem *(^createContactsItemModelWithUserModel)(IMUser *userModel) = ^IMContactsItem *(IMUser *userModel){
        IMContactsItem *model = createContactsItemModel(userModel.avatarPath, userModel.avatarURL, userModel.showName, userModel.detailInfo.remarkInfo, userModel);
        return model;
    };
    for (IMUserGroup *group in contactsData) {
        NSInteger sectionTag = group.tag;
        self.addSection(sectionTag);
        self.setHeader(@"IMContactsHeaderView").toSection(sectionTag).withDataModel(group.groupName);
        
        NSMutableArray *data = [[NSMutableArray alloc]initWithCapacity:group.users.count];
        for (IMUser *user in group.users) {
            IMContactsItem *newModel = createContactsItemModelWithUserModel(user);
            [data addObject:newModel];
        }
        self.addCells(NSStringFromClass([IMContactItemCell class])).toSection(sectionTag).withDataModelArray(data).selectedAction(^ (IMContactsItem *data) {
            IMUser *user = data.userInfo;
            IMUserDetailViewController *detailVC = [[IMUserDetailViewController alloc] initWithUserModel:user];
            [weakSelf tryPushVC:detailVC];
        });
    }
}

- (void)tryPushVC:(__kindof UIViewController *)vc
{
    if (self.pushAction) {
        self.pushAction(vc);
    }
}


#pragma mark - # Delegate
// 拼音首字母检索
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.sectionHeaders;
}

// 检索时空出搜索框
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if(index == 0) {
        [tableView scrollRectToVisible:CGRectMake(0, 0, tableView.width, tableView.height) animated:NO];
        return -1;
    }
    return index;
}
@end
