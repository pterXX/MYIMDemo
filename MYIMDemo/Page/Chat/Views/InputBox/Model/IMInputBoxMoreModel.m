//
//  IMInputBoxMoreModel.m
//  KXiniuCloud
//
//  Created by eims on 2018/5/9.
//  Copyright © 2018年 EIMS. All rights reserved.
//

#import "IMInputBoxMoreModel.h"

@implementation IMInputBoxMoreModel

@end

@implementation IMInputBoxMoreManager

- (NSMutableArray *)moreItemModels
{
    if (!_moreItemModels)
    {
        _moreItemModels = [NSMutableArray array];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"InputBoxMore" ofType:@"plist"];
        NSArray *array = [NSArray arrayWithContentsOfFile:path];
        for (NSDictionary *dic in array)
        {
            IMInputBoxMoreModel *model = [IMInputBoxMoreModel new];
            model.extendId            = dic[@"extendId"];
            model.name                = dic[@"name"];
            model.imageName           = dic[@"imageName"];
            [_moreItemModels addObject:model];
        }
    }
    
    return _moreItemModels;
}

@end

