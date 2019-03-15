//
//  IMContactsSearchResultViewController.m
//  IMChat
//
//  Created by 李伯坤 on 16/1/25.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "IMContactsSearchResultViewController.h"
#import "IMContactItemCell.h"

@interface IMContactsSearchResultViewController ()

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) IMFlexAngel *tableViewAngel;

@property (nonatomic, strong) NSMutableArray *friendsData;

@end

@implementation IMContactsSearchResultViewController

- (void)loadView{
    [super loadView];
    
    _tableView                 = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor colorGrayBG];
    _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    [_tableView setSectionIndexColor:[UIColor colorBlackForNavBar]];
    [_tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.tableViewAngel = [[IMFlexAngel alloc] initWithHostView:self.tableView];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.friendsData = KIMXMPPHelper.userHelper.bothFriendArray;
}

//MARK: UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    IMContactsItem *(^createContactsItemModelWithUserModel)(IMUser *userModel) = ^IMContactsItem *(IMUser *userModel){
        IMContactsItem *model = createContactsItemModel(userModel.avatarPath, userModel.avatarURL, userModel.showName, userModel.detailInfo.remarkInfo, userModel);
        return model;
    };
    
    // 查找数据
    NSString *searchText = [searchController.searchBar.text lowercaseString];
    NSMutableArray *data = [[NSMutableArray alloc] init];
    for (IMUser *user in self.friendsData) {
        if ([user.remarkName containsString:searchText] || [user.username containsString:searchText] || [user.nikeName containsString:searchText] || [user.pinyin containsString:searchText] || [user.pinyinInitial containsString:searchText]) {
            IMContactsItem *model = createContactsItemModelWithUserModel(user);
            [data addObject:model];
        }
    }
    
    // 更新UI
    self.tableViewAngel.clear();
    if (data.count > 0) {
        self.tableViewAngel.addSection(0);
        self.tableViewAngel.setHeader(@"IMContactsHeaderView").toSection(0).withDataModel(@"联系人");
        self.tableViewAngel.addCells(@"IMContactsItemCell").toSection(0).withDataModelArray(data).selectedAction(^ (IMContactsItem *model) {
            if (self.itemSelectedAction) {
                self.itemSelectedAction(self, model.userInfo);
            }
        });
    }
    [self.tableView reloadData];
}

//MARK: UISearchBarDelegate
- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar
{
    [SVProgressHUD showWithStatus:@"语音搜索按钮"];
    [SVProgressHUD dismissWithDelay:1.5];
}

@end
