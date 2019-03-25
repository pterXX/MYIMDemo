//
//  IMFlexibleLayoutSeperatorCell.m
//  IMFlexibleLayoutFrameworkDemo
//
//  Created by 徐世杰 on 2016/12/27.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "IMFlexibleLayoutSeperatorCell.h"

@implementation IMFlexibleLayoutSeperatorModel

- (id)initWithSize:(CGSize)size andColor:(UIColor *)color
{
    if (self = [super init]) {
        self.size = size;
        self.color = color;
    }
    return self;
}

@end

@implementation IMFlexibleLayoutSeperatorCell

+ (CGSize)viewSizeByDataModel:(IMFlexibleLayoutSeperatorModel *)dataModel
{
    return dataModel.size;
}

- (id)init
{
    if (self = [super init]) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)setViewDataModel:(IMFlexibleLayoutSeperatorModel *)dataModel
{
    if (dataModel.color) {
        [self setBackgroundColor:dataModel.color];
    }
}

@end
