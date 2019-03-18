//
//  IMFlexChainViewBatchModel.m
//  zhuanzhuan
//
//  Created by 徐世杰 on 2017/8/15.
//  Copyright © 2017年 转转. All rights reserved.
//

#import "IMFlexChainViewBatchModel.h"
#import "IMFlexibleLayoutSectionModel.h"

#pragma mark - ## IMFlexChainViewBatchBaseModel （批量，基类）
@interface IMFlexChainViewBatchBaseModel()

@property (nonatomic, strong) NSString *className;
@property (nonatomic, strong) NSMutableArray *listData;

@property (nonatomic, strong) NSMutableArray *viewModelArray;
@property (nonatomic, strong) IMFlexibleLayoutSectionModel *sectionModel;
@property (nonatomic, weak) id itemsDelegate;
@property (nonatomic, copy) id (^itemsEventAction)(NSInteger actionType, id data);
@property (nonatomic, copy) void (^itemsSelectedAction)(id data);
@property (nonatomic, assign) NSInteger tag;

@end

@implementation IMFlexChainViewBatchBaseModel

- (id)initWithClassName:(NSString *)className listData:(NSMutableArray *)listData
{
    if (self = [super init]) {
        self.viewModelArray = [[NSMutableArray alloc] init];
        self.className = className;
        self.listData = listData;
    }
    return self;
}

- (id (^)(NSInteger section))toSection
{
    return ^(NSInteger section) {
        for (IMFlexibleLayoutSectionModel *sectionModel in self.listData) {
            if (sectionModel.sectionTag == section) {
                self.sectionModel = sectionModel;
                if (self.viewModelArray.count > 0) {
                    [sectionModel addObjectsFromArray:self.viewModelArray];
                }
                break;
            }
        }
        return self;
    };
}

- (id (^)(NSArray *dataModelArray))withDataModelArray
{
    return ^(NSArray *dataModelArray) {
        for (id model in dataModelArray) {
            IMFlexibleLayoutViewModel *viewModel = [[IMFlexibleLayoutViewModel alloc] init];
            [viewModel setClassName:self.className];
            [viewModel setDataModel:model];
            [viewModel setViewTag:self.tag];
            [viewModel setDelegate:self.itemsDelegate];
            [viewModel setEventAction:self.itemsEventAction];
            [viewModel setSelectedAction:self.itemsSelectedAction];
            [self.viewModelArray addObject:viewModel];
        }
        if (self.sectionModel) {
            [self.sectionModel addObjectsFromArray:self.viewModelArray];
        }
        return self;
    };
}

- (id (^)(id delegate))delegate
{
    return ^(id delegate) {
        [self setItemsDelegate:delegate];
        return self;
    };
}

- (id (^)(id ((^)(NSInteger actionType, id data))))eventAction
{
    return ^(id ((^eventAction)(NSInteger actionType, id data))) {
        [self setItemsEventAction:eventAction];
        return self;
    };
}

- (id (^)(void ((^)(id data))))selectedAction
{
    return ^(void ((^selectedAction)(id data))) {
        [self setItemsSelectedAction:selectedAction];
        return self;
    };
}

- (id (^)(NSInteger viewTag))viewTag
{
    return ^(NSInteger viewTag) {
        [self setTag:viewTag];
        return self;
    };
}

#pragma mark - # Setters
- (void)setItemsDelegate:(id)itemsDelegate
{
    _itemsDelegate = itemsDelegate;
    for (IMFlexibleLayoutViewModel *viewModel in self.viewModelArray) {
        [viewModel setDelegate:itemsDelegate];
    }
}

- (void)setItemsEventAction:(id (^)(NSInteger, id))itemsEventAction
{
    _itemsEventAction = itemsEventAction;
    for (IMFlexibleLayoutViewModel *viewModel in self.viewModelArray) {
        [viewModel setEventAction:itemsEventAction];
    }
}

- (void)setItemsSelectedAction:(void (^)(id))itemsSelectedAction
{
    _itemsSelectedAction = itemsSelectedAction;
    for (IMFlexibleLayoutViewModel *viewModel in self.viewModelArray) {
        [viewModel setSelectedAction:itemsSelectedAction];
    }
}

- (void)setTag:(NSInteger)tag
{
    _tag = tag;
    for (IMFlexibleLayoutViewModel *viewModel in self.viewModelArray) {
        [viewModel setViewTag:tag];
    }
}

@end

#pragma mark - ## IMFlexChainViewBatchModel （批量，添加）
@implementation IMFlexChainViewBatchModel

@end

#pragma mark - ## IMFlexChainViewBatchInsertModel （批量，插入）
typedef NS_OPTIONS(NSInteger, IMFlexInsertArrayDataStatus) {
    IMFlexInsertArrayDataStatusIndex = 1 << 0,
    IMFlexInsertArrayDataStatusBefore = 1 << 1,
    IMFlexInsertArrayDataStatusAfter = 1 << 2,
};

@interface IMFlexChainViewBatchInsertModel ()

@property (nonatomic, assign) IMFlexInsertArrayDataStatus status;

@property (nonatomic, assign) NSInteger insertTag;

@end

@implementation IMFlexChainViewBatchInsertModel

- (id (^)(NSArray *dataModelArray))withDataModelArray
{
    return ^(NSArray *dataModelArray) {
        for (id model in dataModelArray) {
            IMFlexibleLayoutViewModel *viewModel = [[IMFlexibleLayoutViewModel alloc] init];
            [viewModel setClassName:self.className];
            [viewModel setDataModel:model];
            [viewModel setViewTag:self.tag];
            [viewModel setDelegate:self.itemsDelegate];
            [viewModel setEventAction:self.itemsEventAction];
            [viewModel setSelectedAction:self.itemsSelectedAction];
            [self.viewModelArray addObject:viewModel];
        }
        
        [self p_tryInsertCells];
        return self;
    };
}

- (id (^)(NSInteger section))toSection
{
    return ^(NSInteger section) {
        for (IMFlexibleLayoutSectionModel *sectionModel in self.listData) {
            if (sectionModel.sectionTag == section) {
                self.sectionModel = sectionModel;
                break;
            }
        }
        
        [self p_tryInsertCells];
        return self;
    };
}


- (IMFlexChainViewBatchInsertModel *(^)(NSInteger index))toIndex
{
    return ^(NSInteger index) {
        self.status |= IMFlexInsertArrayDataStatusIndex;
        self.insertTag = index;
        
        [self p_tryInsertCells];
        return self;
    };
}

- (IMFlexChainViewBatchInsertModel *(^)(NSInteger sectionTag))beforeCell
{
    return ^(NSInteger sectionTag) {
        self.status |= IMFlexInsertArrayDataStatusBefore;
        self.insertTag = sectionTag;
        
        [self p_tryInsertCells];
        return self;
    };
}

- (IMFlexChainViewBatchInsertModel *(^)(NSInteger sectionTag))afterCell
{
    return ^(NSInteger sectionTag) {
        self.status |= IMFlexInsertArrayDataStatusAfter;
        self.insertTag = sectionTag;
        
        [self p_tryInsertCells];
        return self;
    };
}

- (void)p_tryInsertCells
{
    if (!self.sectionModel || self.viewModelArray.count == 0) {
        return;
    }
    NSInteger index = -1;
    if (self.status & IMFlexInsertArrayDataStatusIndex) {
        index = self.insertTag;
    }
    else if ((self.status & IMFlexInsertArrayDataStatusBefore)|| (self.status & IMFlexInsertArrayDataStatusAfter)) {
        for (NSInteger i = 0; i < self.sectionModel.itemsArray.count; i++) {
            IMFlexibleLayoutViewModel *viewModel = [self.sectionModel objectAtIndex:i];
            if (viewModel.viewTag == self.insertTag) {
                index = (self.status & IMFlexInsertArrayDataStatusBefore) ? i : i + 1;
                break;
            }
        }
    }
    
    if (index >= 0 && index < self.sectionModel.count) {
        NSRange range = NSMakeRange(index, [self.viewModelArray count]);
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.sectionModel insertObjects:self.viewModelArray atIndexes:indexSet];
        self.status = 0;
    }
}

@end

