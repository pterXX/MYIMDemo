//
//  IMFlexibleLayoutViewModel.m
//  IMFlexibleLayoutFrameworkDemo
//
//  Created by 徐世杰 on 2016/12/27.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "IMFlexibleLayoutViewModel.h"
#import "IMFlexibleLayoutViewProtocol.h"

@implementation IMFlexibleLayoutViewModel
@synthesize viewSize = _viewSize;
@synthesize dataModel = _dataModel;

- (id)initWithClassName:(NSString *)className andDataModel:(id)dataModel
{
    return [self initWithClassName:className andDataModel:dataModel viewTag:0];
}

- (id)initWithClassName:(NSString *)className andDataModel:(id)dataModel viewTag:(NSInteger)viewTag
{
    if (self = [super init]) {
        _dataModel = dataModel;
        _className = className;
        _viewTag = viewTag;
        if (className.length > 0) {
            _viewClass = NSClassFromString(className);
        }
        [self updateViewHeight];
    }
    return self;
}

- (void)setDataModel:(id)dataModel
{
    _dataModel = dataModel;
    [self updateViewHeight];
}

- (void)setClassName:(NSString *)className
{
    _className = className;
    if (className.length > 0) {
        _viewClass = NSClassFromString(className);
    }
    [self updateViewHeight];
}

- (void)updateViewHeight
{
    if (self.viewClass) {
        id dataModel = _dataModel;
        if ([(id<IMFlexibleLayoutViewProtocol>)self.viewClass respondsToSelector:@selector(viewSizeByDataModel:)]) {
            _viewSize = [(id<IMFlexibleLayoutViewProtocol>)self.viewClass viewSizeByDataModel:dataModel];
        }
        else if ([(id<IMFlexibleLayoutViewProtocol>)self.viewClass respondsToSelector:@selector(viewHeightByDataModel:)]) {
            CGFloat height = [(id<IMFlexibleLayoutViewProtocol>)self.viewClass viewHeightByDataModel:dataModel];
            _viewSize = CGSizeMake(-1, height);
        }
    }
    else {
        _viewSize = CGSizeZero;
    }
}

@end
