//
//  IMFlexAngel+Private.m
//  IMFlexDemo
//
//  Created by 徐世杰 on 2017/12/14.
//  Copyright © 2017年 徐世杰. All rights reserved.
//

#import "IMFlexAngel+Private.h"
#import "IMFlexibleLayoutSectionModel.h"
#import "IMFlexibleLayoutViewModel.h"

@implementation IMFlexAngel (Private)

- (IMFlexibleLayoutSectionModel *)sectionModelAtIndex:(NSInteger)section
{
    return section < self.data.count ? self.data[section] : nil;
}

- (IMFlexibleLayoutSectionModel *)sectionModelForTag:(NSInteger)sectionTag
{
    for (IMFlexibleLayoutSectionModel *sectionModel in self.data) {
        if (sectionModel.sectionTag == sectionTag) {
            return sectionModel;
        }
    }
    return nil;
}

- (IMFlexibleLayoutViewModel *)viewModelAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath) {
        return nil;
    }
    IMFlexibleLayoutSectionModel *sectionModel = [self sectionModelAtIndex:indexPath.section];
    return [sectionModel objectAtIndex:indexPath.row];
}

- (NSArray<IMFlexibleLayoutViewModel *> *)viewModelsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    for (NSIndexPath *indexPath in indexPaths) {
        IMFlexibleLayoutViewModel *viewModel = [self viewModelAtIndexPath:indexPath];
        if (viewModel) {
            [data addObject:viewModel];
        }
    }
    return data;
}

@end
