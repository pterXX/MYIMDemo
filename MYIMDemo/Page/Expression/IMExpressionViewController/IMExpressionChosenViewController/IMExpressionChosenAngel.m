//
//  IMExpressionChosenAngel.m
//  IMChat
//
//  Created by 李伯坤 on 2018/1/2.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import "IMExpressionChosenAngel.h"

@implementation IMExpressionChosenAngel

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = [super tableView:tableView heightForHeaderInSection:section];
    return height < 0.1 ? 0.00001 : height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat height = [super tableView:tableView heightForFooterInSection:section];
    return height < 0.1 ? 0.00001 : height;
}

@end
