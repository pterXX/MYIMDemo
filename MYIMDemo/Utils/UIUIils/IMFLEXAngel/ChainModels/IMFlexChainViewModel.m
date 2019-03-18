//
//  IMFlexChainViewModel.m
//  zhuanzhuan
//
//  Created by 徐世杰 on 2017/8/15.
//  Copyright © 2017年 转转. All rights reserved.
//

#import "IMFlexChainViewModel.h"
#import "IMFlexibleLayoutSectionModel.h"

#pragma mark - ## IMFlexChainViewBaseModel （单个，基类）
@interface IMFlexChainViewBaseModel()

@property (nonatomic, strong) NSMutableArray *listData;
@property (nonatomic, strong) IMFlexibleLayoutViewModel *viewModel;

@end

@implementation IMFlexChainViewBaseModel

- (id)initWithListData:(NSMutableArray *)listData viewModel:(IMFlexibleLayoutViewModel *)viewModel andType:(IMFlexChainViewType)type;
{
    if (self = [super init]) {
        _type = type;
        self.listData = listData;
        self.viewModel = viewModel;
    }
    return self;
}

- (id (^)(NSInteger section))toSection
{
    return ^(NSInteger section) {
        for (IMFlexibleLayoutSectionModel *sectionModel in self.listData) {
            if (sectionModel.sectionTag == section) {
                if (self.type == IMFlexChainViewTypeCell) {
                    [sectionModel addObject:self.viewModel];
                }
                else if (self.type == IMFlexChainViewTypeHeader) {
                    [sectionModel setHeaderViewModel:self.viewModel];
                }
                else if (self.type == IMFlexChainViewTypeFooter) {
                    [sectionModel setFooterViewModel:self.viewModel];
                }
                break;
            }
        }
        return self;
    };
}

- (id (^)(id dataModel))withDataModel
{
    return ^(id dataModel) {
        [self.viewModel setDataModel:dataModel];
        return self;
    };
}

- (id (^)(id delegate))delegate
{
    return ^(id delegate) {
        [self.viewModel setDelegate:delegate];
        return self;
    };
}

- (id (^)(id ((^)(NSInteger actionType, id data))))eventAction
{
    return ^(id ((^eventAction)(NSInteger actionType, id data))) {
        [self.viewModel setEventAction:eventAction];
        return self;
    };
}

- (id (^)(NSInteger viewTag))viewTag
{
    return ^(NSInteger viewTag) {
        self.viewModel.viewTag = viewTag;
        return self;
    };
}

- (id (^)(void ((^)(id data))))selectedAction
{
    return ^(void ((^eventAction)(id data))) {
        [self.viewModel setSelectedAction:eventAction];
        return self;
    };
}

@end

#pragma mark - ## IMFlexChainViewModel（单个，添加）
@implementation IMFlexChainViewModel

@end

#pragma mark - ## IMFlexChainViewInsertModel（单个，插入）
typedef NS_OPTIONS(NSInteger, IMFlexInsertDataStatus) {
    IMFlexInsertDataStatusIndex = 1 << 0,
    IMFlexInsertDataStatusBefore = 1 << 1,
    IMFlexInsertDataStatusAfter = 1 << 2,
};
@interface IMFlexChainViewInsertModel ()

@property (nonatomic, strong) IMFlexibleLayoutSectionModel *sectionModel;

@property (nonatomic, assign) NSInteger insertTag;

@property (nonatomic, assign) IMFlexInsertDataStatus status;

@end

@implementation IMFlexChainViewInsertModel

- (id (^)(NSInteger section))toSection
{
    return ^(NSInteger section) {
        for (IMFlexibleLayoutSectionModel *model in self.listData) {
            if (model.sectionTag == section) {
                self.sectionModel = model;
            }
        }
        
        [self p_tryInsertCell];
        return self;
    };
}

- (IMFlexChainViewInsertModel *(^)(NSInteger index))toIndex
{
    return ^(NSInteger index) {
        self.status |= IMFlexInsertDataStatusIndex;
        self.insertTag = index;
        
        [self p_tryInsertCell];
        return self;
    };
}

- (IMFlexChainViewInsertModel *(^)(NSInteger sectionTag))beforeCell
{
    return ^(NSInteger sectionTag) {
        self.status |= IMFlexInsertDataStatusBefore;
        self.insertTag = sectionTag;
        
        [self p_tryInsertCell];
        return self;
    };
}

- (IMFlexChainViewInsertModel *(^)(NSInteger sectionTag))afterCell
{
    return ^(NSInteger sectionTag) {
        self.status |= IMFlexInsertDataStatusAfter;
        self.insertTag = sectionTag;
        
        [self p_tryInsertCell];
        return self;
    };
}

- (void)p_tryInsertCell
{
    if (!self.sectionModel) {
        return;
    }
    NSInteger index = -1;
    if (self.status & IMFlexInsertDataStatusIndex) {
        index = self.insertTag;
    }
    else if ((self.status & IMFlexInsertDataStatusBefore)|| (self.status & IMFlexInsertDataStatusAfter)) {
        for (NSInteger i = 0; i < self.sectionModel.itemsArray.count; i++) {
            IMFlexibleLayoutViewModel *viewModel = [self.sectionModel objectAtIndex:i];
            if (viewModel.viewTag == self.insertTag) {
                index = (self.status & IMFlexInsertDataStatusBefore) ? i : i + 1;
                break;
            }
        }
    }
    
    if (index >= 0 && index < self.sectionModel.count) {
        [self.sectionModel insertObject:self.viewModel atIndex:index];
        self.status = 0;
    }
}

@end
