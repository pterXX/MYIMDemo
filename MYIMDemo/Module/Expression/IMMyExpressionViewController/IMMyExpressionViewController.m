//
//  IMMyExpressionViewController.m
//  IMChat
//
//  Created by 徐世杰 on 16/3/10.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "IMMyExpressionViewController.h"
#import "IMExpressionDetailViewController.h"
#import "IMExpressionHelper.h"
#import "IMMyExpressionCell.h"

typedef NS_ENUM(NSInteger, IMMyExpressionVCSectionType) {
    IMMyExpressionVCSectionTypeMine,
    IMMyExpressionVCSectionTypeFunction,
};

@interface IMMyExpressionViewController () <IMMyExpressionCellDelegate>

@end

@implementation IMMyExpressionViewController

- (void)loadView
{
    [super loadView];
    [self setTitle:@"我的表情"];
    [self.view setBackgroundColor:[UIColor colorGrayBG]];
    
    @weakify(self);
    [self addRightBarButtonWithTitle:@"排序" actionBlick:^{
    }];
    
    if (self.navigationController.topViewController == self) {
        [self addLeftBarButtonWithTitle:@"取消" actionBlick:^{
            @strongify(self);
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }
    
    [self loadMyExpressionVCUI];
}

#pragma mark - # UI
- (void)loadMyExpressionVCUI
{
    @weakify(self);
    self.clear();
    
    NSArray *expArray = [IMExpressionHelper sharedHelper].userEmojiGroups;
    if (expArray.count > 0) {
        self.addSection(IMMyExpressionVCSectionTypeMine).sectionInsets(UIEdgeInsetsMake(15, 0, 0, 0));
        self.addCells(@"IMMyExpressionCell").toSection(IMMyExpressionVCSectionTypeMine).withDataModelArray(expArray).selectedAction(^ (id data) {
            @strongify(self);
            IMExpressionDetailViewController *detailVC = [[IMExpressionDetailViewController alloc] initWithGroupModel:data];
            IMPushVC(detailVC);
        });
        
        self.addSection(IMMyExpressionVCSectionTypeFunction).sectionInsets(UIEdgeInsetsMake(20, 0, 40, 0));
    }
    else {
        self.addSection(IMMyExpressionVCSectionTypeFunction).sectionInsets(UIEdgeInsetsMake(15, 0, 30, 0));
    }
    
    // 添加的表情
    self.addCell(CELL_ST_ITEM_NORMAL).toSection(IMMyExpressionVCSectionTypeFunction).withDataModel(IMCreateSettingItem(@"添加的表情")).selectedAction(^ (id data) {

    });
    
    // 购买的表情
    self.addCell(CELL_ST_ITEM_NORMAL).toSection(IMMyExpressionVCSectionTypeFunction).withDataModel(IMCreateSettingItem(@"购买的表情")).selectedAction(^ (id data) {

    });
}

#pragma mark - # Delegate
//MARK: IMMyExpressionCellDelegate
- (void)myExpressionCellDeleteButtonDown:(IMExpressionGroupModel *)group
{
    BOOL ok = [[IMExpressionHelper sharedHelper] deleteExpressionGroupByID:group.gId];
    if (ok) {
        self.deleteCell.byDataModel(group);
        if (self.sectionForTag(IMMyExpressionVCSectionTypeMine).dataModelArray.count == 0) {
            self.deleteSection(IMMyExpressionVCSectionTypeMine);
            self.sectionForTag(IMMyExpressionVCSectionTypeFunction).sectionInsets(UIEdgeInsetsMake(15, 0, 0, 0));
        }
        [self reloadView];
    }
    else {
        [IMUIUtility showErrorHint:@"表情包删除失败"];
    }
}

@end
