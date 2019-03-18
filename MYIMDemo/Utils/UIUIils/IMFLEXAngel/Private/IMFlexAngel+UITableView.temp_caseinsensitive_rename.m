//
//  IMFlexAngel+UITableView.m
//  IMFlexDemo
//
//  Created by 徐世杰 on 2017/12/18.
//  Copyright © 2017年 徐世杰. All rights reserved.
//

#import "IMFlexAngel+UITableView.h"
#import "IMFlexAngel+Private.h"
#import "IMFlexibleLayoutSectionModel.h"
#import "IMFlexibleLayoutViewProtocol.h"
#import "IMFlexTableViewEmptyCell.h"
#import "IMFlexMacros.h"

@implementation IMFlexAngel (UITableView)

//MARK: UICollectionViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    IMFlexibleLayoutSectionModel *sectionModel = [self sectionModelAtIndex:section];
    return [sectionModel count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMFlexibleLayoutSectionModel *sectionModel = [self sectionModelAtIndex:indexPath.section];
    IMFlexibleLayoutViewModel *model = [sectionModel objectAtIndex:indexPath.row];
    
    UITableViewCell<IMFlexibleLayoutViewProtocol> *cell;
    if (!model || !model.viewClass) {
        NSLog(@"!!!!! tableViewCell不存在，将使用空白Cell：%@", model.className);
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([IMFlexTableViewEmptyCell class]) forIndexPath:indexPath];
        [cell setTag:model.viewTag];
        return cell;
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:model.className forIndexPath:indexPath];
    
    if ([cell respondsToSelector:@selector(setViewDataModel:)]) {
        [cell setViewDataModel:model.dataModel];
    }
    if ([cell respondsToSelector:@selector(setViewDelegate:)]) {
        [cell setViewDelegate:model.delegate ? model.delegate : self];
    }
    if ([cell respondsToSelector:@selector(setViewEventAction:)]) {
        [cell setViewEventAction:model.eventAction];
    }
    if ([cell respondsToSelector:@selector(viewIndexPath:sectionItemCount:)]) {
        [cell viewIndexPath:indexPath sectionItemCount:sectionModel.count];
    }
    [cell setTag:model.viewTag];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView<IMFlexibleLayoutViewProtocol> *view = nil;
    IMFlexibleLayoutSectionModel *sectionModel = [self sectionModelAtIndex:section];
    if (sectionModel.headerViewModel && sectionModel.headerViewModel.viewClass) {
        view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionModel.headerViewModel.className];
        
        if ([view respondsToSelector:@selector(setViewDataModel:)]) {
            [view setViewDataModel:sectionModel.headerViewModel.dataModel];
        }
        if ([view respondsToSelector:@selector(setViewEventAction:)]) {
            [view setViewEventAction:sectionModel.headerViewModel.eventAction];
        }
        if ([view respondsToSelector:@selector(setViewDelegate:)]) {
            [view setViewDelegate:sectionModel.headerViewModel.delegate ? sectionModel.headerViewModel.delegate : self];
        }
        if ([view respondsToSelector:@selector(viewIndexPath:sectionItemCount:)]) {
            [view viewIndexPath:nil sectionItemCount:sectionModel.count];
        }
        [view setTag:sectionModel.headerViewModel.viewTag];
    }
    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UITableViewHeaderFooterView<IMFlexibleLayoutViewProtocol> *view = nil;
    IMFlexibleLayoutSectionModel *sectionModel = [self sectionModelAtIndex:section];
    if (sectionModel.footerViewModel && sectionModel.footerViewModel.viewClass) {
        view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionModel.footerViewModel.className];
        
        if ([view respondsToSelector:@selector(setViewDataModel:)]) {
            [view setViewDataModel:sectionModel.footerViewModel.dataModel];
        }
        if ([view respondsToSelector:@selector(setViewEventAction:)]) {
            [view setViewEventAction:sectionModel.headerViewModel.eventAction];
        }
        if ([view respondsToSelector:@selector(setViewDelegate:)]) {
            [view setViewDelegate:sectionModel.footerViewModel.delegate ? sectionModel.footerViewModel.delegate : self];
        }
        if ([view respondsToSelector:@selector(viewIndexPath:sectionItemCount:)]) {
            [view viewIndexPath:nil sectionItemCount:sectionModel.count];
        }
        [view setTag:sectionModel.footerViewModel.viewTag];
    }
    
    return view;
}
//MARK: UICollectionViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    IMFlexibleLayoutViewModel *viewModel = [self viewModelAtIndexPath:indexPath];
    if (viewModel.selectedAction) {
        viewModel.selectedAction(viewModel.dataModel);
    }
}

//MARK: IMFlexibleLayoutFlowLayoutDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMFlexibleLayoutViewModel *model = [self viewModelAtIndexPath:indexPath];
    CGFloat height = model ? model.viewSize.height : 0;
    height = height < 0 ? tableView.frame.size.height * -height : height;
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    IMFlexibleLayoutSectionModel *sectionModel = [self sectionModelAtIndex:section];
    IMFlexibleLayoutViewModel *model = sectionModel.headerViewModel;
    CGFloat height = model ? model.viewSize.height : 0;
    height = height < 0 ? tableView.frame.size.height * -height : height;
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    IMFlexibleLayoutSectionModel *sectionModel = [self sectionModelAtIndex:section];
    IMFlexibleLayoutViewModel *model = sectionModel.footerViewModel;
    CGFloat height = model ? model.viewSize.height : 0;
    height = height < 0 ? tableView.frame.size.height * -height : height;
    return height;
}

@end
