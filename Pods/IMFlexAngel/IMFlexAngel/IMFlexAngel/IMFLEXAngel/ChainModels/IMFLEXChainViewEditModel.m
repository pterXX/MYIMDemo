//
//  IMFLEXChainViewEditModel.m
//  IMFLEXDemo
//
//  Created by 李伯坤 on 2017/12/11.
//  Copyright © 2017年 李伯坤. All rights reserved.
//

#import "IMFLEXChainViewEditModel.h"
#import "IMFlexibleLayoutSectionModel.h"

#pragma mark - ## IMFLEXChainViewEditModel (单个)
@interface IMFLEXChainViewEditModel ()

@property (nonatomic, assign) IMFLEXChainViewEditType editType;

@property (nonatomic, strong) NSArray *listData;

@end

@implementation IMFLEXChainViewEditModel

- (instancetype)initWithType:(IMFLEXChainViewEditType)type andListData:(NSArray *)listData
{
    if (self = [super init]) {
        self.editType = type;
        self.listData = listData;
    }
    return self;
}

- (id (^)(NSInteger viewTag))byViewTag
{
    return ^id(NSInteger viewTag) {
        for (IMFlexibleLayoutSectionModel *sectionModel in self.listData) {
            for (IMFlexibleLayoutViewModel *viewModel in sectionModel.itemsArray) {
                if (viewModel.viewTag == viewTag) {
                    return [self p_executeWithSectionModel:sectionModel viewModel:viewModel];
                }
            }
        }
        return nil;
    };
}

- (id (^)(id dataModel))byDataModel
{
    return ^id(id dataModel) {
        for (IMFlexibleLayoutSectionModel *sectionModel in self.listData) {
            for (IMFlexibleLayoutViewModel *viewModel in sectionModel.itemsArray) {
                if (viewModel.dataModel == dataModel) {
                    return [self p_executeWithSectionModel:sectionModel viewModel:viewModel];
                }
            }
        }
        return nil;
    };
}

- (id (^)(NSString *className))byViewClassName
{
    return ^id(NSString *className) {
        for (IMFlexibleLayoutSectionModel *sectionModel in self.listData) {
            for (IMFlexibleLayoutViewModel *viewModel in sectionModel.itemsArray) {
                if ([viewModel.className isEqualToString:className]) {
                    return [self p_executeWithSectionModel:sectionModel viewModel:viewModel];
                }
            }
        }
        return nil;
    };
}

- (id (^)(NSIndexPath *indexPath))atIndexPath
{
    return ^id(NSIndexPath *indexPath) {
        IMFlexibleLayoutSectionModel *sectionModel = (indexPath.section >=0 && indexPath.section < self.listData.count) ? self.listData[indexPath.section] : nil;
        if (sectionModel) {
            IMFlexibleLayoutViewModel *viewModel = (indexPath.row >= 0 && indexPath.row < sectionModel.itemsArray.count) ? sectionModel.itemsArray[indexPath.row] : nil;
            if (viewModel) {
                return [self p_executeWithSectionModel:sectionModel viewModel:viewModel];
            }
        }
        return nil;
    };
}

#pragma mark - # Private Methods
- (id)p_executeWithSectionModel:(IMFlexibleLayoutSectionModel *)sectionModel viewModel:(IMFlexibleLayoutViewModel *)viewModel
{
    if (self.editType == IMFLEXChainViewEditTypeDelete) {
        [sectionModel.itemsArray removeObject:viewModel];
        return nil;
    }
    else if (self.editType == IMFLEXChainViewEditTypeUpdate) {
        [viewModel updateViewHeight];
        return nil;
    }
    else if (self.editType == IMFLEXChainViewEditTypeDataModel) {
        return viewModel.dataModel;
    }
    else if (self.editType == IMFLEXChainViewEditTypeHas) {
        return viewModel.dataModel;
    }
    return nil;
}

@end

#pragma mark - ## IMFLEXChainViewBatchEditModel (批量)
@interface IMFLEXChainViewBatchEditModel ()

@property (nonatomic, strong) NSArray *listData;

@property (nonatomic, assign) IMFLEXChainViewEditType editType;

@end

@implementation IMFLEXChainViewBatchEditModel

- (instancetype)initWithType:(IMFLEXChainViewEditType)type andListData:(NSArray *)listData
{
    if (self = [super init]) {
        self.editType = type;
        self.listData = listData;
    }
    return self;
}

- (NSArray *(^)(void))all
{
    return ^NSArray *(void) {
        NSMutableArray *viewModelArray = [[NSMutableArray alloc] init];
        for (IMFlexibleLayoutSectionModel *sectionModel in self.listData) {
            if (self.editType == IMFLEXChainViewEditTypeDelete) {       // 删除
                [sectionModel.itemsArray removeAllObjects];
            }
            else if (self.editType == IMFLEXChainViewEditTypeDataModel) {       // 获取
                [viewModelArray addObjectsFromArray:sectionModel.itemsArray];
            }
        }
        if (self.editType == IMFLEXChainViewEditTypeUpdate) {
            [self p_updateViewModelArray:viewModelArray];
        }
        return [self dataModelArrayByViewModelArray:viewModelArray];
    };
}

- (NSArray *(^)(NSInteger viewTag))byViewTag
{
    return ^NSArray *(NSInteger viewTag) {
        NSMutableArray *viewModelArray = [[NSMutableArray alloc] init];
        for (IMFlexibleLayoutSectionModel *sectionModel in self.listData) {
            NSMutableArray *data = [[NSMutableArray alloc] init];
            for (IMFlexibleLayoutViewModel *viewModel in sectionModel.itemsArray) {
                if (viewModel.viewTag == viewTag) {
                    [data addObject:viewModel];
                }
            }
            if (self.editType == IMFLEXChainViewEditTypeDelete) {
                [self p_deleteWithSectionModel:sectionModel viewModelArray:data];
            }
            [viewModelArray addObjectsFromArray:data];
        }
        if (self.editType == IMFLEXChainViewEditTypeUpdate) {
            [self p_updateViewModelArray:viewModelArray];
        }
        if (self.editType == IMFLEXChainViewEditTypeDataModel) {
            return [self dataModelArrayByViewModelArray:viewModelArray];
        }
        return nil;
    };
}

- (NSArray *(^)(id dataModel))byDataModel
{
    return ^NSArray *(id dataModel) {
        NSMutableArray *viewModelArray = [[NSMutableArray alloc] init];
        for (IMFlexibleLayoutSectionModel *sectionModel in self.listData) {
            NSMutableArray *data = [[NSMutableArray alloc] init];
            for (IMFlexibleLayoutViewModel *viewModel in sectionModel.itemsArray) {
                if (viewModel.dataModel == dataModel) {
                    [data addObject:viewModel];
                }
            }
            if (self.editType == IMFLEXChainViewEditTypeDelete) {
                [self p_deleteWithSectionModel:sectionModel viewModelArray:data];
            }
            [viewModelArray addObjectsFromArray:data];
        }
        if (self.editType == IMFLEXChainViewEditTypeUpdate) {
            [self p_updateViewModelArray:viewModelArray];
        }
        return nil;
    };
}

- (NSArray *(^)(NSString *className))byViewClassName
{
    return ^NSArray *(NSString *className) {
        NSMutableArray *viewModelArray = [[NSMutableArray alloc] init];
        for (IMFlexibleLayoutSectionModel *sectionModel in self.listData) {
            NSMutableArray *data = [[NSMutableArray alloc] init];
            for (IMFlexibleLayoutViewModel *viewModel in sectionModel.itemsArray) {
                if ([viewModel.className isEqualToString:className]) {
                    [data addObject:viewModel];
                }
            }
            if (self.editType == IMFLEXChainViewEditTypeDelete) {
                [self p_deleteWithSectionModel:sectionModel viewModelArray:data];
            }
            [viewModelArray addObjectsFromArray:data];
        }
        if (self.editType == IMFLEXChainViewEditTypeUpdate) {
            [self p_updateViewModelArray:viewModelArray];
        }
        if (self.editType == IMFLEXChainViewEditTypeDataModel) {
            return [self dataModelArrayByViewModelArray:viewModelArray];
        }
        return nil;
    };
}

- (NSArray *)p_deleteWithSectionModel:(IMFlexibleLayoutSectionModel *)sectionModel viewModelArray:(NSArray *)viewModelArray
{
    for (IMFlexibleLayoutViewModel *viewModel in viewModelArray) {
        if (viewModel == sectionModel.headerViewModel) {
            sectionModel.headerViewModel = nil;
        }
        else if (viewModel == sectionModel.footerViewModel) {
            sectionModel.footerViewModel = nil;
        }
        else {
            [sectionModel.itemsArray removeObject:viewModel];
        }
    }
    return nil;
}

- (void)p_updateViewModelArray:(NSArray *)viewModelArray
{
    for (IMFlexibleLayoutViewModel *viewModel in viewModelArray) {
        [viewModel updateViewHeight];
    }
}

- (NSArray *)dataModelArrayByViewModelArray:(NSArray *)viewModelArray
{
    NSMutableArray *data = [[NSMutableArray alloc] initWithCapacity:viewModelArray.count];
    for (IMFlexibleLayoutViewModel *viewModel in viewModelArray) {
        [data addObject:viewModel.dataModel];
    }
    return data;
}

@end

