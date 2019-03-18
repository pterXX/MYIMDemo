//
//  TLSearchController.m
//  TLChat
//
//  Created by 徐世杰 on 16/3/7.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "IMSearchController.h"
#import "UIImage+Color.h"

@implementation IMSearchController
{
    UIStatusBarStyle lastBarStyle;
}

+ (IMSearchController *)createWithResultsContrller:(UIViewController<IMSearchResultControllerProtocol> *)resultVC
{
    if (!resultVC) {
        return nil;
    }
    IMSearchController *searchController = [[IMSearchController alloc] initWithSearchResultsController:resultVC];
    [searchController setSearchResultsUpdater:resultVC];
    return searchController;
}

- (id)initWithSearchResultsController:(UIViewController<IMSearchResultControllerProtocol>  *)searchResultsController
{
    if (self = [super initWithSearchResultsController:searchResultsController]) {
        [self setDelegate:searchResultsController];
        self.definesPresentationContext = YES;
        
        // searchResultsController
        searchResultsController.edgesForExtendedLayout = UIRectEdgeNone;
        
        // searchBar
        [self.searchBar setPlaceholder:@"搜索"];
        [self.searchBar setFrame:CGRectMake(0, 0, IMSCREEN_WIDTH, IMSEARCHBAR_HEIGHT)];
        [self.searchBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorGrayBG]]];
        [self.searchBar setBarTintColor:[UIColor colorGrayBG]];
        [self.searchBar setTintColor:[UIColor colorGreenDefault]];
        [self.searchBar setDelegate:searchResultsController];
        [self.searchBar setTranslucent:NO];
        UITextField *tf = [[[self.searchBar.subviews firstObject] subviews] lastObject];
        [tf.layer setMasksToBounds:YES];
        [tf.layer setBorderWidth:IMBORDER_WIDTH_1PX];
        [tf.layer setBorderColor:[UIColor colorGrayLine].CGColor];
        [tf.layer setCornerRadius:5.0f];
        
        for (UIView *view in self.searchBar.subviews[0].subviews) {
            if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                UIView *bg = [[UIView alloc] init];
                [bg setBackgroundColor:[UIColor colorGrayBG]];
                [view addSubview:bg];
                [bg mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(0);
                }];
                
                UIView *line = [[UIView alloc] init];
                [line setBackgroundColor:[UIColor colorGrayLine]];
                [view addSubview:line];
                [line mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.and.right.and.bottom.mas_equalTo(0);
                    make.height.mas_equalTo(IMBORDER_WIDTH_1PX);
                }];
                break;
            }
        }
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    lastBarStyle = [UIApplication sharedApplication].statusBarStyle;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:lastBarStyle  animated:YES];
}

- (void)setEnableVoiceInput:(BOOL)showVoiceButton
{
    _enableVoiceInput = showVoiceButton;
    if (showVoiceButton) {
        [self.searchBar setShowsBookmarkButton:YES];
        [self.searchBar setImage:[UIImage imageNamed:@"searchBar_voice"] forSearchBarIcon:UISearchBarIconBookmark state:UIControlStateNormal];
        [self.searchBar setImage:[UIImage imageNamed:@"searchBar_voice_HL"] forSearchBarIcon:UISearchBarIconBookmark state:UIControlStateHighlighted];
    }
    else {
        [self.searchBar setShowsBookmarkButton:NO];
    }
}

@end
