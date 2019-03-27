//
//  IMExpressionMoreSearchCell.m
//  IMChat
//
//  Created by 李伯坤 on 2017/7/21.
//  Copyright © 2017年 李伯坤. All rights reserved.
//

#import "IMExpressionMoreSearchCell.h"
#import "IMExpressionSearchResultViewController.h"
#import "IMSearchController.h"

@interface IMExpressionMoreSearchCell ()

@property (nonatomic, strong) IMSearchController *searchController;

@property (nonatomic, copy) id (^eventAction)(NSInteger, id);

@end

@implementation IMExpressionMoreSearchCell

#pragma mark - # Protocol
+ (CGSize)viewSizeByDataModel:(id)dataModel
{
    return CGSizeMake(SCREEN_WIDTH, IMSEARCHBAR_HEIGHT);
}

- (void)setViewEventAction:(id (^)(NSInteger, id))eventAction
{
    self.eventAction = eventAction;
}

#pragma mark - # Public Methods
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        @weakify(self);
        IMExpressionSearchResultViewController *searchResultVC = [[IMExpressionSearchResultViewController alloc] init];
        [searchResultVC setItemClickAction:^(IMExpressionSearchResultViewController *searchController, id data) {
            @strongify(self);
            [self.searchController setActive:NO];
            if (self.eventAction) {
                self.eventAction(0, data);
            }
        }];
        self.searchController = [IMSearchController createWithResultsContrller:searchResultVC];
        [self.searchController.searchBar setPlaceholder:@"搜索表情"];
        [self.contentView addSubview:self.searchController.searchBar];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!CGSizeEqualToSize(self.bounds.size, self.searchController.searchBar.frame.size)) {
        [self.searchController.searchBar setSize:self.bounds.size];
    }
}

@end
