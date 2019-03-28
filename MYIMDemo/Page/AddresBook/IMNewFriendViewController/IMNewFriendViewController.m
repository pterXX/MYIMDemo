//
//  IMNewFriendViewController.m
//  MYIMDemo
//
//  Created by admin on 2019/3/15.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "IMNewFriendViewController.h"
#import "IMSearchController.h"
#import "IMNewFriendAngel.h"
#import "IMFriendFindViewController.h"

@interface IMNewFriendViewController ()
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) IMNewFriendAngel *tableViewAngel;

@property (nonatomic, strong) IMSearchController *searchController;
@end

@implementation IMNewFriendViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadListUIWithData];
}

- (void)loadListUIWithData{
    [self.tableViewAngel resetListWithContactsData:[IMFriendHelper sharedFriendHelper].addFriendJidArray];
    [self.tableView reloadData];
}

#pragma mark - # Private Methods
- (void)im_addSubViews
{
    [self setTitle:@"新的朋友"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    @weakify(self);
    [self addRightBarButtonWithTitle:@"添加朋友" actionBlick:^{
        @strongify(self);
//        IMAddContactsViewController *addFriendVC = [[IMAddContactsViewController alloc] init];
//        IMPushVC(addFriendVC);
    }];
    
    self.tableView                              = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor              = [UIColor colorGrayBG];
    self.tableView.separatorStyle               = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight           = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.tableHeaderView              = self.searchController.searchBar;
    [self.tableView setSectionIndexColor:[UIColor colorBlackForNavBar]];
    [self.tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    self.tableView.tableFooterView              = [UIView new];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.tableViewAngel = [[IMNewFriendAngel alloc] initWithHostView:self.tableView pushAction:^(__kindof UIViewController * _Nonnull vc) {
        @strongify(self);
        IMPushVC(vc);
    }];
    [self.tableViewAngel setBtnAction:^{
        @strongify(self);
        [self loadListUIWithData];
    }];
}

#pragma mark - # Getters
- (IMSearchController *)searchController
{
    if (_searchController == nil) {
        IMFriendFindViewController *searchResultVC = [[IMFriendFindViewController alloc] init];
        _searchController = [[IMSearchController alloc] initWithSearchResultsController:searchResultVC];
        [_searchController.searchBar setPlaceholder:@"请输入账号"];
    }
    return _searchController;
}

@end
