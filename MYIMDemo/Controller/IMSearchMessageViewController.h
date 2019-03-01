//
//  IMSearchMessageViewController.h
//  MYIMDemo
//
//  Created by 徐世杰 on 2019/2/28.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSearchMessageViewController : IMBaseViewController <UISearchResultsUpdating, UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) UINavigationController *navigationBarCtrl;


@end

NS_ASSUME_NONNULL_END
