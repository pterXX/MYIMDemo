//
//  IMInputBoxMoreView.m
//  KXiniuCloud
//
//  Created by eims on 2018/5/7.
//  Copyright © 2018年 EIMS. All rights reserved.
//

#import "IMInputBoxMoreView.h"

#import "IMInputBoxMoreItemView.h"
#import "IMInputBoxMoreModel.h"
#import "IMInputBoxMoreUnitView.h"

@interface IMInputBoxMoreView()
// 页数
@property (nonatomic, assign) NSInteger pageNumber;
// moreItemView数组
@property (nonatomic, strong) NSMutableArray *moreItemViews;

@end

@implementation IMInputBoxMoreView

- (NSMutableArray *)moreItemViews
{
    if (!_moreItemViews) {
        _moreItemViews = [NSMutableArray arrayWithCapacity:1];
        
        for (int i = 0; i < 2; i ++) {
            IMInputBoxMoreItemView *moreItemView = [[IMInputBoxMoreItemView alloc] initWithFrame:CGRectMake(0, 0, IMSCREEN_WIDTH, INPUT_BOX_MORE_VIEW_HEIGHT)];
            [_moreItemViews addObject:moreItemView];
        }
    }
    
    return _moreItemViews;
}

- (NSInteger)pageNumber
{
    if (!_pageNumber)
    {
        IMInputBoxMoreManager *inputBoxMoreManager = [[IMInputBoxMoreManager alloc] init];
        NSInteger page = inputBoxMoreManager.moreItemModels.count / 8;
        NSInteger remainder = inputBoxMoreManager.moreItemModels.count % 8;
        _pageNumber = page + remainder;
    }
    
    return _pageNumber;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.backgroundColor = [IMColorTools colorWithHexString:@"0xeeeeee"];
    self.topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IMSCREEN_WIDTH, 1)];
    self.topLine.backgroundColor = KLineColor;
    [self addSubview:self.topLine];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, IMSCREEN_WIDTH, INPUT_BOX_MORE_VIEW_HEIGHT)];
    self.scrollView.contentSize = CGSizeMake(IMSCREEN_WIDTH, 0);
    self.scrollView.contentOffset = CGPointMake(0, 0);
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    
    self.pageCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, IMSCREEN_WIDTH, 15)];
    self.pageCtrl.backgroundColor = [UIColor clearColor];
    self.pageCtrl.pageIndicatorTintColor = [IMColorTools colorWithHexString:@"0xd8d8d8"];
    self.pageCtrl.currentPageIndicatorTintColor = [IMColorTools colorWithHexString:@"0x8e8e8e"];
    self.pageCtrl.hidesForSinglePage = YES;
    [self addSubview:self.pageCtrl];
    
    IMInputBoxMoreItemView *moreItemView = self.moreItemViews.firstObject;
    [self.scrollView addSubview:moreItemView];
    
}

@end
