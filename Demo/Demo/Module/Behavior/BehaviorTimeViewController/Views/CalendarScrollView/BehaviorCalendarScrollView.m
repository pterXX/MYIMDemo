//
//  BehaviorCalendarScrollView.m
//  Demo
//
//  Created by admin on 2019/4/19.
//  Copyright © 2019 admin. All rights reserved.
//

#import "BehaviorCalendarScrollView.h"
#import "BehaviorTimeCell.h"
#import "BehaviorDetailViewController.h"

@interface BehaviorCalendarScrollView()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic ,strong) NSMutableArray *dataSource;
@end

@implementation BehaviorCalendarScrollView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self p_loadUI];
        
        [self p_initData];
    }
    return self;
}

#pragma mark ================= Private Methods =================
- (void)p_loadUI {
    self.tableView.backgroundColor              = UIColorFromRGB(0xf6f6f6);
    self.tableView.separatorStyle               = UITableViewCellSeparatorStyleNone; //  取消分割线
    self.tableView.estimatedRowHeight           = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.tableFooterView              = [UIView new];
    self.tableView.delegate                     = self;
    self.tableView.dataSource                   = self;
    self.tableView.bounces                      = NO;
}


//  初始化数据
- (void)p_initData{
    self.dataSource = [NSMutableArray array];
    [self.dataSource addObject:@(1)];
    [self.dataSource addObject:@(2)];
    [self.dataSource addObject:@(3)];
    [self.dataSource addObject:@(4)];
    [self.dataSource addObject:@(5)];
    [self.dataSource addObject:@(6)];
    [self.dataSource addObject:@(7)];
    [self.dataSource addObject:@(8)];
    [self.dataSource addObject:@(9)];
    [self.dataSource addObject:@(10)];
    [self.dataSource addObject:@(11)];
    [self.dataSource addObject:@(12)];
    [self.dataSource addObject:@(13)];
    [self.dataSource addObject:@(14)];
}


#pragma mark ================= UITableViewDelegate,UITableViewDataSource =================
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *Identifier = @"cellIdentifier";
    //  BehaviorTimeCell
    BehaviorTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[BehaviorTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
        //  注册3D Touch
        if ([self respondsToSelector:@selector(traitCollection)]) {
            if ([self.traitCollection respondsToSelector:@selector(forceTouchCapability)]
                && self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable
                && self.viewController) {
                [self.viewController registerForPreviewingWithDelegate:(id)self sourceView:cell];
            }
        }
        
        //  聊天按钮点击回调的Block
        [cell setChatBtnPressBlock:^(id  _Nonnull model) {
            NSLog(@"model %@",model);
        }];
    }
    //  赋值显示数据
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //  获取高度
    return [BehaviorTimeCell viewHeightByDataModel:self.dataSource[indexPath.row]];
}

#pragma mark ================= UIViewControllerPreviewingDelegate  =================
- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location NS_AVAILABLE_IOS(9_0) {
    //  3D touch
    BehaviorTimeCell *cell = (BehaviorTimeCell *)[previewingContext sourceView];
    previewingContext.sourceRect = cell.bgView.frame;
    // 创建要预览的控制器
    BehaviorDetailViewController *presentationVC = [[BehaviorDetailViewController alloc] init];
    return presentationVC;
}

- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit NS_AVAILABLE_IOS(9_0) {
    if(self.viewController){
        //  进行跳转
        [self.viewController showViewController:viewControllerToCommit sender:self];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
