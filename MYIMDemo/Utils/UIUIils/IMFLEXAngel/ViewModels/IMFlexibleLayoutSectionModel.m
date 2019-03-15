//
//  IMFlexibleLayoutSectionModel.m
//  IMFlexibleLayoutFrameworkDemo
//
//  Created by 李伯坤 on 2016/12/27.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "IMFlexibleLayoutSectionModel.h"

@implementation IMFlexibleLayoutSectionModel

- (id)init
{
    if (self = [super init]) {
        _itemsArray = [[NSMutableArray alloc] init];
        self.minimumLineSpacing = 0.0f;
        self.minimumInteritemSpacing = 0.0f;
        self.sectionInsets = UIEdgeInsetsZero;
    }
    return self;
}

#pragma mark - # Section Header
- (CGSize)headerViewSize
{
    return [self.headerViewModel viewSize];
}

#pragma mark - # Section Footer
- (CGSize)footerViewSize
{
    return [self.footerViewModel viewSize];
}

#pragma mark - # Items
- (NSUInteger)count
{
    return self.itemsArray.count;
}

- (void)addObject:(IMFlexibleLayoutViewModel *)object
{
    if (!object) {
        return;
    }
    [self.itemsArray addObject:object];
}

- (void)addObjectsFromArray:(NSArray<IMFlexibleLayoutViewModel *> *)otherArray
{
    if (otherArray) {
        [self.itemsArray addObjectsFromArray:otherArray];
    }
}

- (void)insertObject:(IMFlexibleLayoutViewModel *)object atIndex:(NSUInteger)objectIndex;
{
    if (!object) {
        return;
    }
    [self.itemsArray insertObject:object atIndex:objectIndex];
}

- (void)insertObjects:(NSArray<IMFlexibleLayoutViewModel *> *)objects atIndexes:(NSIndexSet *)indexes
{
    if (objects) {
        [self.itemsArray insertObjects:objects atIndexes:indexes];
    }
}

- (id)objectAtIndex:(NSUInteger)index
{
    return index < self.itemsArray.count ? self.itemsArray[index] : nil;
}

- (void)removeObjectAtIndex:(NSUInteger)index
{
    index < self.itemsArray.count ? [self.itemsArray removeObjectAtIndex:index] : nil;
}

- (void)removeObject:(IMFlexibleLayoutViewModel *)object
{
    if ([self.itemsArray containsObject:object]) {
        [self.itemsArray removeObject:object];
    }
}

- (id)dataModelAtIndex:(NSUInteger)index
{
    IMFlexibleLayoutViewModel *viewModel = [self objectAtIndex:index];
    return viewModel.dataModel;
}

@end

