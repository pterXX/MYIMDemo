//
//  IMInputBoxMoreItemView.m
//  KXiniuCloud
//
//  Created by eims on 2018/5/7.
//  Copyright © 2018年 EIMS. All rights reserved.
//

#import "IMInputBoxMoreItemView.h"


#import "IMInputBoxMoreModel.h"
#import "IMInputBoxMoreUnitView.h"

@implementation IMInputBoxMoreItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self showEmojiGroupDetailFromIndex:0 count:8];
    }
    return self;
}

- (void)showEmojiGroupDetailFromIndex:(NSInteger)fromIndex count:(NSInteger)count
{
    IMInputBoxMoreManager  *inputBoxMoreManager = [[IMInputBoxMoreManager alloc] init];
    IMInputBoxMoreUnitView *lastUnitView = nil;
    
    NSArray *moreModels = inputBoxMoreManager.moreItemModels;
    
    NSInteger cycleIndex = 0;
    NSInteger differenceValue = 0;
    if (count > moreModels.count)
    {
        differenceValue = count - moreModels.count;
    }
    count = count - differenceValue;
    
    for (NSInteger i = fromIndex; i < fromIndex + count ; i ++)
    {
        IMInputBoxMoreUnitView *unitView = nil;
        if (cycleIndex < self.moreUnitViews.count)
        {
            unitView = [self.moreUnitViews objectAtIndex:cycleIndex];
        }
        else
        {
            if (cycleIndex % 4 != 0)
            {
                CGFloat originY = lastUnitView != nil ? lastUnitView.mj_y : INPUT_BOX_MORE_ITEM_H_INTERVAL;
                unitView = [[IMInputBoxMoreUnitView alloc] initWithFrame:CGRectMake(lastUnitView.maxX + INPUT_BOX_MORE_ITEM_V_INTERVAL, originY, INPUT_BOX_MORE_ITEM_WIDTH, INPUT_BOX_MORE_ITEM_HEIGHT)];
            }
            else
            {
                CGFloat originY = lastUnitView != nil ? lastUnitView.maxY : INPUT_BOX_MORE_ITEM_H_INTERVAL;
                unitView = [[IMInputBoxMoreUnitView alloc] initWithFrame:CGRectMake(INPUT_BOX_MORE_ITEM_V_INTERVAL, originY, INPUT_BOX_MORE_ITEM_WIDTH, INPUT_BOX_MORE_ITEM_HEIGHT)];
            }

            [self addSubview:unitView];
            [self.moreUnitViews addObject:unitView];
            lastUnitView = unitView;
        }

        cycleIndex += 1;
        [unitView addTarget:self action:@selector(didselecteMoreUnitView:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i >= inputBoxMoreManager.moreItemModels.count || i < 0)
        {
            [unitView setHidden:YES];
        }
        else
        {
            IMInputBoxMoreModel *moreModel = moreModels[i];
            unitView.tag = i;
            [unitView setMoreModel:moreModel];
            [unitView setHidden:NO];
        }
    }
}

- (void)didselecteMoreUnitView:(IMInputBoxMoreUnitView *)unitView
{
    IMInputBoxMoreStatus inputBoxMoreStatus = unitView.tag + 1;
    
    [IMNotificationCenter postNotificationName:@"IMInputBoxDidSelectedMoreView" object:nil userInfo:@{@"status":@(inputBoxMoreStatus)}];
    
}

@end
