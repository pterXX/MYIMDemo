//
//  IMFlexChainSectionModel.m
//  zhuanzhuan
//
//  Created by 徐世杰 on 2017/8/15.
//  Copyright © 2017年 转转. All rights reserved.
//

#import "IMFlexChainSectionModel.h"
#import "IMFlexibleLayoutSectionModel.h"
#import "IMFlexMacros.h"

#pragma mark - ## IMFlexChainSectionBaseModel (基类)
@interface IMFlexChainSectionBaseModel ()

@property (nonatomic, strong) IMFlexibleLayoutSectionModel *sectionModel;

@end

@implementation IMFlexChainSectionBaseModel

- (instancetype)initWithSectionModel:(IMFlexibleLayoutSectionModel *)sectionModel
{
    if (self = [super init]) {
        self.sectionModel = sectionModel;
    }
    return self;
}

- (id (^)(CGFloat minimumLineSpacing))minimumLineSpacing
{
    return ^(CGFloat minimumLineSpacing) {
        [self.sectionModel setMinimumLineSpacing:minimumLineSpacing];
        return self;
    };
}

- (id (^)(CGFloat minimumInteritemSpacing))minimumInteritemSpacing
{
    return ^(CGFloat minimumInteritemSpacing) {
        [self.sectionModel setMinimumInteritemSpacing:minimumInteritemSpacing];
        return self;
    };
}

- (id (^)(UIEdgeInsets sectionInsets))sectionInsets
{
    return ^(UIEdgeInsets sectionInsets) {
        [self.sectionModel setSectionInsets:sectionInsets];
        return self;
    };
}

- (id (^)(UIColor *backgrounColor))backgrounColor
{
    return ^(UIColor *backgrounColor) {
        [self.sectionModel setBackgroundColor:backgrounColor];
        return self;
    };
}

@end

#pragma mark - ## IMFlexChainSectionModel （添加）
@implementation IMFlexChainSectionModel

@end

#pragma mark - ## IMFlexChainSectionInsertModel （插入）
@interface IMFlexChainSectionInsertModel()

@property (nonatomic, strong) NSMutableArray *listData;

@end

@implementation IMFlexChainSectionInsertModel

- (instancetype)initWithSectionModel:(IMFlexibleLayoutSectionModel *)sectionModel listData:(NSMutableArray *)listData
{
    if (self = [super initWithSectionModel:sectionModel]) {
        self.listData = listData;
    }
    return self;
}

- (IMFlexChainSectionInsertModel *(^)(NSInteger index))toIndex
{
    return ^(NSInteger index) {
        [self p_insertToListDataAtIndex:index];
        return self;
    };
}

- (IMFlexChainSectionInsertModel *(^)(NSInteger sectionTag))beforeSection
{
    return ^(NSInteger sectionTag) {
        for (int i = 0; i < self.listData.count; i++) {
            IMFlexibleLayoutSectionModel *model = self.listData[i];
            if (model.sectionTag == sectionTag) {
                [self p_insertToListDataAtIndex:i];
                break;
            }
        }
        return self;
    };
}

- (IMFlexChainSectionInsertModel *(^)(NSInteger sectionTag))afterSection
{
    return ^(NSInteger sectionTag) {
        for (int i = 0; i < self.listData.count; i++) {
            IMFlexibleLayoutSectionModel *model = self.listData[i];
            if (model.sectionTag == sectionTag) {
                [self p_insertToListDataAtIndex:i + 1];
                break;
            }
        }
        return self;
    };
}

- (BOOL)p_insertToListDataAtIndex:(NSInteger)index
{
    if (self.listData && index >= 0 && index < self.listData.count) {
        [self.listData insertObject:self.sectionModel atIndex:index];
        self.listData = nil;
        return YES;
    }
    NSLog(@"!!!!! section插入失败");
    return NO;
}

@end

#pragma mark - ## IMFlexChainSectionEditModel （编辑）
@implementation IMFlexChainSectionEditModel

#pragma mark 获取数据源
- (NSArray *)dataModelArray
{
    NSArray *viewModelArray = self.sectionModel.itemsArray;
    NSMutableArray *data = [[NSMutableArray alloc] initWithCapacity:viewModelArray.count];
    for (IMFlexibleLayoutViewModel *viewModel in viewModelArray) {
        if (viewModel.dataModel) {
            [data addObject:viewModel.dataModel];
        }
        else {
            [data addObject:[NSNull null]];
        }
    }
    return data;
}

- (id)dataModelForHeader
{
    return self.sectionModel.headerViewModel.dataModel;
}

- (id)dataModelForFooter
{
    return self.sectionModel.footerViewModel.dataModel;
}

/// 根据viewTag获取数据源
- (id (^)(NSInteger viewTag))dataModelByViewTag
{
    return ^(NSInteger viewTag) {
        for (IMFlexibleLayoutViewModel *viewModel in self.sectionModel.itemsArray) {
            if (viewModel.viewTag == viewTag) {
                return viewModel.dataModel;
            }
        }
        if (self.sectionModel.headerViewModel.viewTag == viewTag) {
            return self.sectionModel.headerViewModel.dataModel;
        }
        else if (self.sectionModel.footerViewModel.viewTag == viewTag) {
            return self.sectionModel.footerViewModel.dataModel;
        }
        return (id)nil;
    };
}

/// 根据viewTag批量获取数据源
- (NSArray *(^)(NSInteger viewTag))dataModelArrayByViewTag
{
    return ^(NSInteger viewTag) {
        NSMutableArray *data = [[NSMutableArray alloc] init];
        for (IMFlexibleLayoutViewModel *viewModel in self.sectionModel.itemsArray) {
            if (viewModel.viewTag == viewTag) {
                if (viewModel.dataModel) {
                    [data addObject:viewModel.dataModel];
                }
                else {
                    [data addObject:[NSNull null]];
                }
            }
        }
        if (self.sectionModel.headerViewModel.viewTag == viewTag) {
            if (self.sectionModel.headerViewModel.dataModel) {
                [data addObject:self.sectionModel.headerViewModel.dataModel];
            }
            else {
                [data addObject:[NSNull null]];
            }
        }
        if (self.sectionModel.footerViewModel.viewTag == viewTag) {
            if (self.sectionModel.footerViewModel.dataModel) {
                [data addObject:self.sectionModel.footerViewModel.dataModel];
            }
            else {
                [data addObject:[NSNull null]];
            }
        }
        return data;
    };
}

#pragma mark 删除
- (IMFlexChainSectionEditModel *(^)(void))clear
{
    return ^(void) {
        self.sectionModel.headerViewModel = nil;
        self.sectionModel.footerViewModel = nil;
        [self.sectionModel.itemsArray removeAllObjects];
        return self;
    };
}

- (IMFlexChainSectionEditModel *(^)(void))clearCells
{
    return ^(void) {
        [self.sectionModel.itemsArray removeAllObjects];
        return self;
    };
}

- (IMFlexChainSectionEditModel *(^)(void))deleteHeader
{
    return ^(void) {
        self.sectionModel.headerViewModel = nil;
        return self;
    };
}

- (IMFlexChainSectionEditModel *(^)(void))deleteFooter
{
    return ^(void) {
        self.sectionModel.footerViewModel = nil;
        return self;
    };
}

- (IMFlexChainSectionEditModel *(^)(NSInteger tag))deleteCellByTag
{
    return ^(NSInteger tag) {
        for (IMFlexibleLayoutViewModel *viewModel in self.sectionModel.itemsArray) {
            if (viewModel.viewTag == tag) {
                [self.sectionModel removeObject:viewModel];
                break;
            }
        }
        return self;
    };
}

- (IMFlexChainSectionEditModel *(^)(NSInteger tag))deleteAllCellsByTag
{
    return ^(NSInteger tag) {
        NSMutableArray *deleteData = @[].mutableCopy;
        for (IMFlexibleLayoutViewModel *viewModel in self.sectionModel.itemsArray) {
            if (viewModel.viewTag == tag) {
                [deleteData addObject:viewModel];
            }
        }
        for (IMFlexibleLayoutViewModel *viewModel in deleteData) {
            [self.sectionModel removeObject:viewModel];
        }
        return self;
    };
}

#pragma mark 刷新
- (IMFlexChainSectionEditModel *(^)(void))update
{
    return ^(void) {
        [self.sectionModel.headerViewModel updateViewHeight];
        [self.sectionModel.footerViewModel updateViewHeight];
        for (IMFlexibleLayoutViewModel *viewModel in self.sectionModel.itemsArray) {
            [viewModel updateViewHeight];
        }
        return self;
    };
}

- (IMFlexChainSectionEditModel *(^)(void))updateCells
{
    return ^(void) {
        for (IMFlexibleLayoutViewModel *viewModel in self.sectionModel.itemsArray) {
            [viewModel updateViewHeight];
        }
        return self;
    };
}

- (IMFlexChainSectionEditModel *(^)(void))updateHeader
{
    return ^(void) {
        [self.sectionModel.headerViewModel updateViewHeight];
        return self;
    };
}

- (IMFlexChainSectionEditModel *(^)(void))updateFooter
{
    return ^(void) {
        [self.sectionModel.footerViewModel updateViewHeight];
        return self;
    };
}

- (IMFlexChainSectionEditModel *(^)(NSInteger tag))updateCellByTag
{
    return ^(NSInteger tag) {
        for (IMFlexibleLayoutViewModel *viewModel in self.sectionModel.itemsArray) {
            if (viewModel.viewTag == tag) {
                [viewModel updateViewHeight];
                break;
            }
        }
        return self;
    };
}

- (IMFlexChainSectionEditModel *(^)(NSInteger tag))updateAllCellsByTag
{
    return ^(NSInteger tag) {
        for (IMFlexibleLayoutViewModel *viewModel in self.sectionModel.itemsArray) {
            if (viewModel.viewTag == tag) {
                [viewModel updateViewHeight];
            }
        }
        return self;
    };
}

@end
