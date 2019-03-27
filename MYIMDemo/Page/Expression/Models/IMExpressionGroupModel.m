//
//  IMExpressionGroupModel.m
//  IMChat
//
//  Created by 李伯坤 on 16/2/19.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "IMExpressionGroupModel.h"
#import "NSFileManager+IMChat.h"
#import "IMExpressionHelper.h"

@implementation IMExpressionGroupModel
@synthesize path = _path;

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"gId" : @"eId",
             @"iconURL" : @"coverUrl",
             @"name" : @"eName",
             @"detail" : @"memo1",
             @"count" : @"picCount",
             @"bannerId" : @"aId",
             @"bannerURL" : @"URL",
             @"groupInfo" : @"memo",
             };
}

- (void)setData:(NSMutableArray *)data
{
    _data = data;
    self.count = data.count;
    [self p_updateExpressionItemGid];
}

- (void)setGId:(NSString *)gId
{
    _gId = gId;
    
    [self p_updateExpressionItemGid];
}

- (id)objectAtIndex:(NSUInteger)index
{
    return [self.data objectAtIndex:index];
}

#pragma mark - # Private Methods
- (void)p_updateExpressionItemGid
{
    for (IMExpressionModel *model in self.data) {
        model.gid = self.gId;
    }
}

#pragma mark - # Getters
- (NSString *)path
{
    if (_path == nil && self.gId != nil) {
        _path = [NSFileManager pathExpressionForGroupID:self.gId];
    }
    return _path;
}

- (NSString *)iconPath
{
    if (_iconPath == nil && self.path != nil) {
        _iconPath = [NSString stringWithFormat:@"%@icon_%@", self.path, self.gId];
    }
    return _iconPath;
}

@end
